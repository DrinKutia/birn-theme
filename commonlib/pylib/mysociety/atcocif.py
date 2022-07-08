#
# atcocif.py:
# ATCO-CIF transport journey file loader.
#
# Copyright (c) 2008 UK Citizens Online Democracy. All rights reserved.
# Email: francis@mysociety.org; WWW: http://www.mysociety.org/
#
# $Id: atcocif.py,v 1.56 2009-04-23 16:34:45 francis Exp $
#

# To do later:
# Test is_set_down, is_pick_up maybe a bit more
# See if timing point indicator tells you if points are interpolated
# Date range exceptions are probably broken in some way, will need lots of
#   testing if this is used for something that relies on it.

"""Loads files in the ATCO-CIF file format, which is used in the UK to specify
public transport journeys for accessibility planning by the National Public
Transport Data Repository (NPTDR).

Specification is here: http://www.pti.org.uk/CIF/atco-cif-spec.pdf 

atcocif.py does a lightweight, low level parse of the file. It aims to be
tolerant of deviations from the specification only where those have been found
in the wild.

There are some helper functions, which interpret the ATCO-CIF file. For
example, is_valid_on_date tests whether a particular journey applies on a given
specific day (allowing for weekends, bank holidays, school holidays etc.)

The simplest ATCO-CIF file is just a header, with no further records.
>>> atco = ATCO()
>>> atco.read_string('ATCO-CIF0510      Buckinghamshire - BUS               ATCOPT20080125165808')
>>> atco.file_header.file_originator
'Buckinghamshire - BUS'

"""

import os
import sys
import re
import datetime
import mx.DateTime
import logging
import StringIO
import zipfile
import math
import progressbar

###########################################################
# Main class

class ATCO(object):
    def __init__(self, assume_no_holidays = True, show_progress = False):
        '''Assume_no_holidays assumes there are no school or bank holidays on the days
        you are quering for.'''
        self.journeys = []
        self.locations = []
        self.vehicle_types = []
        self.assume_no_holidays = assume_no_holidays
        self.nearby_max_distance = None
        self.show_progress = show_progress
        self.line_patches = {}
        self.locations_to_ignore = {}
        self.vehicle_type_to_code = {}

        self.restrict_date_range_start = None
        self.restrict_date_range_end = None
        self.file_loading_number = 0

    def restrict_to_date_range(self, restrict_date_range_start, restrict_date_range_end):
        '''Ignore exceptional date ranges outside this range. Use this, e.g. for
        NPTDR data where it is only valid in a week. This will avoid worrying
        about unnecessary contradictions in the exceptional date range data if
        they lie outside where we care about. '''
        assert restrict_date_range_start <= restrict_date_range_end
        self.restrict_date_range_start = restrict_date_range_start
        self.restrict_date_range_end = restrict_date_range_end

    def register_line_patches(self, line_patches):
        '''line_patches is a dictionary from an input line to a replacement line,
        used to correct minor errors in specific data files.

        >>> atco = ATCO()
        >>> atco.register_line_patches( 
        ... { "QSNGW    6B1820070521200712071111100  2B02P10452TRAIN           I" : 
        ... "QSNGW    XXXX20070521200712071111100  2B02P10452TRAIN           I" } )
        >>> atco.read_string("""ATCO-CIF0510                       70 - RAIL        ATCORAIL20080124115909
        ... QSNGW    6B1820070521200712071111100  2B02P10452TRAIN           I
        ... """)
        >>> atco.journeys[0].id
        'GW-XXXX'
        '''
        self.line_patches = line_patches

    def register_locations_to_ignore(self, locations_to_ignore):
        '''removed_stops is a set of identifiers of stops which should
        be thrown away. 
        
        For example, the Lincolnshire NPTDR data has some stops which aren't
        real stops, but just indicate that destinations vary depending on
        bookings.'''

        self.locations_to_ignore = locations_to_ignore

    def __str__(self):
        ret = str(self.file_header) + "\n"
        for journey in self.journeys:
            ret = ret + str(journey) + "\n"
        for location in self.locations:
            ret = ret + str(location) + "\n"
        for vehicle_type in self.vehicle_types:
            ret = ret + str(vehicle_type) + "\n"
        return ret

    def read_files(self, files):
        '''Loads in multiple ATCO-CIF files.'''
        for file in files:
            self.read(file)

    def read(self, f):
        '''Loads an ATCO-CIF file from a file.

        >>> import tempfile
        >>> n = tempfile.NamedTemporaryFile()
        >>> n.write('ATCO-CIF0510      Buckinghamshire - COACH             ATCOPT20080126111426')
        >>> n.flush()
        >>> atco = ATCO()
        >>> atco.read(n.name)
        >>> n.close()

        Will also read CIF files from within a ZIP file.
        '''

        # See if it is a zip file, in which case load each file within it
        if zipfile.is_zipfile(f):
            zf = zipfile.ZipFile(f, 'r')
            for zipfilename in zf.namelist():
                logging.info("reading zip file " + f + ", internal file " + zipfilename)
                data = zf.read(zipfilename)
                # XXX won't recurse into zip files in zip files, but so what
                self.read_string(data)
        else:
            # Otherwise, just read it
            logging.info("reading CIF file " + f)
            return self.read_file_handle(open(f), os.stat(f)[6])

    def read_string(self, s):
        '''Loads an ATCO-CIF file from a string.

        >>> atco = ATCO()
        >>> atco.read_string('ATCO-CIF0510      Buckinghamshire - COACH             ATCOPT20080126111426')
        '''
        h = StringIO.StringIO(s)
        return self.read_file_handle(h, len(s))

    def item_loaded(self, item):
        ''' Override this function if, for example, you want to stream the
        journeys in, rather than store them all in Python in memory.'''

        if isinstance(item, JourneyHeader):
            self.journeys.append(item)
        elif isinstance(item, Location):
            self.locations.append(item)
        elif isinstance(item, VehicleType):
            self.vehicle_types.append(item)
        else:
            assert False

    def read_file_handle(self, h, file_len):
        '''Loads an ATCO-CIF file from a file handle.'''
        self.handle = h

        self.file_loading_number += 1
        if not self.file_loading_number in self.vehicle_type_to_code:
            self.vehicle_type_to_code[self.file_loading_number] = {}

        if self.show_progress:
            widgets = ['ATCO-CIF: ', progressbar.Percentage(), ' ', progressbar.Bar(marker=progressbar.RotatingMarker()),
                       ' ', progressbar.ETA(), ' ', progressbar.FileTransferSpeed()]
            pbar = progressbar.ProgressBar(widgets=widgets, maxval=file_len).start()

        line = self.handle.readline().strip("\n\r")
        self.file_header = FileHeader(line)

        # Load in every record - each record is one line of the file
        current_item = None
        for line in self.handle:
            if self.show_progress:
                pbar.update(self.handle.tell())

            line = line.strip("\n\r")
            if not line:
                continue # Ignore blank lines (never present in real CIF files, but can't hurt)
            #logging.debug(line)

            # apply any line patches
            if line in self.line_patches:
                line = self.line_patches[line]

            record_identity = line[0:2]
            record = None

            try:
                # Journeys - store the clump of records relating to one journey 
                if record_identity == 'QS':
                    if current_item != None:
                        self.item_loaded(current_item)
                    current_item = JourneyHeader(line, self.file_loading_number, assume_no_holidays = True)
                elif record_identity == 'QE':
                    assert isinstance(current_item, JourneyHeader)
                    current_item.add_date_running_exception(JourneyDateRunning(line), self.restrict_date_range_start, self.restrict_date_range_end)
                elif record_identity == 'QO':
                    assert isinstance(current_item, JourneyHeader)
                    jo = JourneyOrigin(line)
                    if jo.location not in self.locations_to_ignore:
                        current_item.add_hop(jo)
                elif record_identity == 'QI':
                    assert isinstance(current_item, JourneyHeader)
                    ji = JourneyIntermediate(line)
                    if ji.location not in self.locations_to_ignore:
                        current_item.add_hop(ji)
                elif record_identity == 'QT':
                    assert isinstance(current_item, JourneyHeader)
                    jd = JourneyDestination(line)
                    if jd.location not in self.locations_to_ignore:
                        current_item.add_hop(jd)
                
                # Locations - store the group of records relating to one location
                elif record_identity == 'QL':
                    new_item = Location(line)
                    if new_item.location not in self.locations_to_ignore:
                        if current_item != None:
                            self.item_loaded(current_item)
                        current_item = new_item
                elif record_identity == 'QB':
                    la = LocationAdditional(line)
                    if la.location not in self.locations_to_ignore:
                        assert isinstance(current_item, Location)
                        current_item.add_additional(la)

                # Vehicle types
                elif record_identity == 'QV':
                    new_item = VehicleType(line)
                    if current_item != None:
                        self.item_loaded(current_item)
                    current_item = new_item
                    # There aren't many vehicle types, just always index them
                    if current_item.vehicle_type in self.vehicle_type_to_code[self.file_loading_number]:
                        if self.vehicle_type_to_code[self.file_loading_number][current_item.vehicle_type] != current_item.type_code():
                            raise Exception("Inconsistent vehicle type codes; previously had " + self.vehicle_type_to_code[self.file_loading_number][current_item.vehicle_type] + " for type " + current_item.vehicle_type + " when this line has " + current_item.type_code() + ", line is: " + line)
                    else:
                        self.vehicle_type_to_code[self.file_loading_number][current_item.vehicle_type] = current_item.type_code()
                # Other
                elif record_identity in [
                    'QP',  # Operator record
                    'QD',  # Route description record
                    'QN'  # Journey note
                ]:
                    logging.debug("Ignoring record type '" + record_identity + "'")
                else:
                    import pdb;pdb.set_trace()
                    raise Exception("Unknown record type '" + record_identity + "'")
            except:
                # Show what line we were on, and reraise exception
                logging.error("Exception caught reading line: " + line)
                raise

        if current_item != None:
            self.item_loaded(current_item)

        if self.show_progress:
            pbar.finish()

    def index_by_short_codes(self):
        '''Make dictionaries so it is quick to look up all journeys visiting a
        particular location, and to get details about a location from its identifier.

        >>> atco = ATCO()
        >>> atco.read_string("""ATCO-CIF0510                       70 - RAIL        ATCORAIL20080124115909
        ... QSNGW    6B1820070521200712071111100  2B02P10452TRAIN           I
        ... QO9100MDNHEAD 0549URLT1  
        ... QI9100FURZEP  05530553T   T1  
        ... QI9100COOKHAM 05560556T   T1  
        ... QI9100BORNEND 06010605T   T1  
        ... QT9100MARLOW  0612   T1  
        ... QSNGW    6B1A20070521200712071111100  2B04P10456TRAIN           I
        ... QO9100MDNHEAD 0608URLT1  
        ... QI9100FURZEP  06120612T   T1  
        ... QI9100COOKHAM 00000000O   T1  
        ... QT9100BORNEND 0620   T1  
        ... QLN9100COOKHAM Cookham Rail Station                             RE0057284
        ... QBN9100COOKHAM 488690  185060                                                  
        ... """)
        >>> atco.index_by_short_codes()
        >>> journeys_visiting_cookham = atco.journeys_visiting_location["9100COOKHAM"]
        >>> [x.id for x in journeys_visiting_cookham]
        ['GW-6B1A', 'GW-6B18']
        >>> atco.location_from_id["9100COOKHAM"].long_description()
        'Cookham Rail Station'
        '''

        self.journeys_visiting_location = {}
        for journey in self.journeys:
            for hop in journey.hops:
                if hop.location not in self.journeys_visiting_location:
                    self.journeys_visiting_location[hop.location] = set()

                if journey in self.journeys_visiting_location[hop.location]:
                    if hop == journey.hops[0] and hop == journey.hops[-1]:
                        # if it's a simple loop, starting and ending at same point, then that's OK
                        logging.debug("journey " + journey.id + " loops")
                        pass
                    else:
                        assert "same location %s appears twice in one journey %s, and not at start/end" % (hop.location, journey.id)

                self.journeys_visiting_location[hop.location].add(journey)

        self.location_from_id = {}
        for location in self.locations:
            self.location_from_id[location.location] = location

    def _test_vehicle_type_to_code(self):
        ''' An index to let you look up type of a journey given its vehicle_type is
        always made. The type codes are single characters, e.g. 'B' for bus, 'T'
        for train.

        >>> atco = ATCO()
        >>> atco.read_string("""ATCO-CIF0510          Oxfordshire - BUS               ATCOPT20081211043503
        ... QSNT09115110120070421219912310001000  498       EABUS           I
        ... QVNEABUS   Bus                     
        ... """)
        >>> atco.journeys[0].vehicle_type
        'EABUS'
        >>> atco.vehicle_type_to_code[atco.file_loading_number][atco.journeys[0].vehicle_type]
        'B'

        If types are inconsistent, it will give an error.

        >>> atco.read_string("""ATCO-CIF0510          Oxfordshire - BUS               ATCOPT20081211043503
        ... QVNEABUS   Bus                     
        ... QVNEABUS   Coach                   
        ... """)
        Traceback (most recent call last):
            ...
        Exception: Inconsistent vehicle type codes; previously had B for type EABUS when this line has C, line is: QVNEABUS   Coach                   
        '''

    def index_nearby_locations(self, nearby_max_distance):
        ''' Creates an index to make it quick to look up stops near other stops. The distance
        is the maximum distance to include stops of.

        >>> atco = ATCO()
        >>> atco.read_string("""ATCO-CIF0510                       70 - RAIL        ATCORAIL20080124115909
        ... QLN9100FURZEP  Furze Platt Rail Station                         RE0043271
        ... QBN9100FURZEP  488294  182334                                                  
        ... QLN9100COOKHAM Cookham Rail Station                             RE0057284
        ... QBN9100COOKHAM 488690  185060                                                  
        ... """)
        >>> atco.index_by_short_codes()
        >>> atco.index_nearby_locations(3600) # c. 2 miles
        >>> atco.nearby_locations[atco.location_from_id['9100COOKHAM']]
        {Location('9100FURZEP'): 2754.6128584612393}
        >>> atco.index_nearby_locations(10)
        >>> atco.nearby_locations[atco.location_from_id['9100COOKHAM']]
        {}
        '''

        # see if we already have the index for this distance
        if nearby_max_distance == self.nearby_max_distance:
            return
        
        # otherwise, make it
        self.nearby_max_distance = None
        self.nearby_locations = {}
        for location in self.locations:
            self.nearby_locations.setdefault(location, {})
            easting = location.additional.grid_reference_easting
            northing = location.additional.grid_reference_northing
            for other_location in self.locations:
                if location == other_location:
                    continue
                other_easting = other_location.additional.grid_reference_easting
                other_northing = other_location.additional.grid_reference_northing
                sqdist = (easting-other_easting)**2 + (northing-other_northing)**2
                if sqdist < nearby_max_distance * nearby_max_distance:
                    dist = math.sqrt(sqdist)
                    logging.debug("index_nearby_locations: %s (%d,%d) is %d away from %s (%d,%d)" % (location, easting, northing, dist, other_location.location, other_easting, other_northing))
                    self.nearby_locations[location].setdefault(other_location, dist)
        self.nearby_max_distance = nearby_max_distance

    def statistics(self):
        ''' Returns a dictionary of statistics about the loaded timetables. '''
        stats = {}
        stats['journey_count'] = len(self.journeys)
        stats['location_count'] = len(self.locations)

        c = 0
        tot = 0
        for location, nearby_dict in self.nearby_locations.iteritems():
            c += 1
            tot += len(nearby_dict)
        assert c == len(self.locations)
        stats['average_nearby_locations'] = float(tot) / c

        c = 0
        tot_direct_connecting_locations = 0
        tot_journeys_per_connecting_pair = 0
        for location in self.locations:
            direct_connecting_locations = {}
            hopcount = 0
            for journey in self.journeys_visiting_location[location.location]:
                for hop in journey.hops:
                    direct_connecting_locations[hop.location] = 1
                    hopcount += 1
            c += 1
            tot_direct_connecting_locations += len(direct_connecting_locations)
            tot_journeys_per_connecting_pair += (hopcount / len(direct_connecting_locations))
        stats['average_direct_connecting_locations'] = float(tot_direct_connecting_locations) / c
        stats['average_journeys_per_connecting_pair'] = float(tot_journeys_per_connecting_pair) / c

        return stats


###########################################################
# Helper functions and classes

def parse_time(time_string):
    '''Converts a time string from an ATCO-CIF field into a Python time object.

    >>> parse_time('0549')
    datetime.time(5, 49)
    >>> parse_time('2410')
    datetime.time(0, 10)
    >>> parse_time('9999')
    Traceback (most recent call last):
        ...
    ValueError: hour must be in 0..23
    '''
    assert len(time_string) == 4
    hour = int(time_string[0:2])
    # Some authorities use 24 for journeys that cross midnight, some wrap round
    # to 0. We change 24 so that it always wraps to 0.
    if hour >= 24 and hour < 28:
        hour = hour - 24
    minute = int(time_string[2:4])
    try:
        return datetime.time(hour, minute, 0)
    except:
        import pdb;pdb.set_trace()

def parse_date(date_string):
    '''Converts a date string from an ATCO-CIF field into a Python date object.

    >>> parse_date('20080204')
    datetime.date(2008, 2, 4)
    >>> parse_date('99999999') # appears in some bus timetables e.g. ATCO_040_BUS.CIF in 2007 sample data
    datetime.date(9999, 12, 31)
    >>> parse_date('20083001')
    Traceback (most recent call last):
        ...
    ValueError: month must be in 1..12
    '''
    assert len(date_string) == 8
    if date_string == '99999999' or date_string == '        ':
        date_string = '99991231'
    return datetime.date(
        int(date_string[0:4]), int(date_string[4:6]), int(date_string[6:8]),
    )

def parse_date_time(date_string, time_string):
    '''Converts a date and time string from an ATCO-CIF field into a Python
    combined date/time object. Unlike timetable times above, these full time
    stamps also contain seconds.

    >>> parse_date_time('20090204','155901')
    datetime.datetime(2009, 2, 4, 15, 59, 1)
    '''
    assert len(date_string) == 8
    if len(time_string) == 4: 
        time_string = "%s00" % time_string 
    assert len(time_string) == 6
 
    return datetime.datetime(
        int(date_string[0:4]), int(date_string[4:6]), int(date_string[6:8]),
        int(time_string[0:2]), int(time_string[2:4]), int(time_string[4:6]), 0
    )

def canonicalise_location(location):
    '''Removes excess spaces, and makes the location uppercase.

    >>> canonicalise_location("TTA 2322")
    'TTA2322'
    >>> canonicalise_location('9300eri')
    '9300ERI'
    '''
    location = location.strip().upper()
    location = location.replace(" ", "")
    return location

class BoolWithReason:
    '''Behaves as a boolean, only stores an explanatory string as well.
    
    >>> bwr1 = BoolWithReason(False, "the frobnitz was klutzed")
    >>> bwr1 and "yes" or "no"
    'no'
    >>> bwr1.reason
    'the frobnitz was klutzed'
    >>> bwr1
    BoolWithReason(False, 'the frobnitz was klutzed')

    >>> bwr2 = BoolWithReason(True, "all was good")
    >>> bwr2 and "yes" or "no"
    'yes'
    >>> bwr2
    BoolWithReason(True, 'all was good')
    '''

    def __init__(self, value, reason):
        self.value = value
        self.reason = reason

    def __repr__(self):
        return "BoolWithReason(" + repr(self.value) + ", " + repr(self.reason) + ")"

    def __nonzero__(self):
        return self.value



###########################################################
# Base record class

class CIFRecord:
    """Base class of individual records from the ATCO-CIF file. Stores the line of
    text the the derived classes parser into members of the class. 

    Each line has a two character identifier at its start, which is checked against
    the expected identifier passed in.

    >>> c = CIFRecord("QT9100BORNEND 0620   T1", "QT")
    >>> c = CIFRecord("QT9100BORNEND 0620   T1", "QX")
    Traceback (most recent call last):
        ...
    Exception: CIF identifier 'QT' when expected 'QX'
    """

    def __init__(self, line, record_identity):
        assert len(record_identity) == 2
        self.line = line
        assert len(line) >= 2
        self.record_identity = line[0:2]
        if self.record_identity != record_identity:
            raise Exception, "CIF identifier '" + self.record_identity + "' when expected '" + record_identity + "'"

    def __str__(self):
        ret = self.__class__.__name__ + "\n"
        ret = ret + "\tline: " + self.line + "\n"
        keys = self.__dict__.keys()
        keys.sort()
        for key in keys:
            if key != 'line' and key != 'hops':
                ret = ret + "\t" + key + ": " + repr(self.__dict__[key]) + "\n"

        return ret

class FileHeader(CIFRecord):
    """ATC-CIF files begin with a special header that cannot be nonsense.

    >>> atco = ATCO()
    >>> atco.read_string(u'ATnonsense')
    Traceback (most recent call last):
        ...
    Exception: ATCO-CIF header line incorrectly formatted: ATnonsense

    Here is an example of a valid header. The space padded strings within the header
    are trimmed, and the production date/time is parsed out as a Python object.

    >>> atco.read_string(u'ATCO-CIF0510                       70 - RAIL        ATCORAIL20080124115909')
    >>> atco.file_header.version_major, atco.file_header.version_minor
    (5, 10)
    >>> atco.file_header.file_originator
    u'70 - RAIL'
    >>> atco.file_header.source_product
    u'ATCORAIL'
    >>> atco.file_header.production_datetime
    datetime.datetime(2008, 1, 24, 11, 59, 9)
    """

    def __init__(self, line):
        CIFRecord.__init__(self, line, "AT")

        matches = re.match('^ATCO-CIF(\d\d)(\d\d)(.{32})(.{16})(\d{8})(\d{4,6})$', line) 
        if not matches:
            raise Exception("ATCO-CIF header line incorrectly formatted: " + line)
        self.version_major = int(matches.group(1))
        self.version_minor = int(matches.group(2))
        self.file_originator = matches.group(3).strip()
        self.source_product = matches.group(4).strip()
        self.production_datetime = parse_date_time(matches.group(5), matches.group(6))

###########################################################
# Journey record classes

class JourneyHeader(CIFRecord):
    '''Header of a journey record. It stores all associated records too, and so 
    represents the whole journey. 
    
    >>> jh = JourneyHeader('QSNGW    6B3920070521200712071111100  2B82P10553TRAIN           I', 1)
    >>> jh.transaction_type # New/Delete/Revise
    'N'
    >>> jh.operator
    'GW'
    >>> jh.unique_journey_identifier
    '6B39'
    >>> jh.id
    'GW-6B39'
    >>> jh.first_date_of_operation
    datetime.date(2007, 5, 21)
    >>> jh.last_date_of_operation
    datetime.date(2007, 12, 7)
    >>> jh.operates_on_day_of_week
    [False, True, True, True, True, True, False, False]
    >>> jh.school_term_time
    ' '
    >>> jh.bank_holidays
    ' '
    >>> jh.route_number
    '2B82'
    >>> jh.running_board
    'P10553'
    >>> jh.vehicle_type
    'TRAIN'
    >>> jh.registration_number
    ''
    >>> jh.route_direction
    'I'

    JourneyDateRunning records are stored in self.date_running_exceptions - see
    the JourneyDateRunning definition for examples.

    JourneyOrigin, JourneyIntermediate, JourneyDestination records are stored
    in self.hops - see add_hop below for examples.
    '''

    def __init__(self, line, file_loading_number, assume_no_holidays = True):
        CIFRecord.__init__(self, line, "QS")
        self.assume_no_holidays = True
        self.file_loading_number = file_loading_number

        matches = re.match('^QS([NDR])(.{4})(.{6})(\d{8})(\d{8}| {8})([01]{7})([ SH])([ ABXG])(.{4})(.{6})(.{8})(.{8})(.)$', line)
        if not matches:
            raise Exception("Journey header line incorrectly formatted: " + line)

        self.transaction_type = matches.group(1)
        assert self.transaction_type == 'N' # code doesn't handle other types yet
        self.operator = matches.group(2).strip()
        self.unique_journey_identifier = matches.group(3).strip()
        self.first_date_of_operation = parse_date(matches.group(4))
        self.last_date_of_operation = parse_date(matches.group(5))
        self.operates_on_day_of_week = [None] * 8
        day_of_week_group = matches.group(6)
        for day_of_week in range(1, 8):
            self.operates_on_day_of_week[day_of_week] = bool(int(day_of_week_group[day_of_week - 1]))
        self.operates_on_day_of_week[0] = bool(int(day_of_week_group[6])) # fill in Sunday at both ends for convenience
        self.school_term_time = matches.group(7)
        self.bank_holidays = matches.group(8)
        self.route_number = matches.group(9)
        self.running_board = matches.group(10).strip()
        self.vehicle_type = matches.group(11).strip().upper()
        self.registration_number = matches.group(12).strip()
        self.route_direction = matches.group(13)

        # Operator code and journey identifier are unique together
        self.id = self.operator + "-" + self.unique_journey_identifier

        self.hops = []
        self.hop_lines = {}
        #self.hop_locations = {}
        self.date_running_exceptions = []

        self.cache_valid = None
        self.cache_valid_date = None

    def __str__(self):
        ret = CIFRecord.__str__(self) + "\n"
        counter = 0
        for hop in self.hops:
            counter = counter + 1
            ret = ret + "\t" + str(counter) + ". " + str(hop) + "\n"
        return ret

    def add_date_running_exception(self, exception, restrict_date_range_start = None, restrict_date_range_end = None):
        '''See JourneyDateRunning for documentation of this function.'''
        assert isinstance(exception, JourneyDateRunning)

        # see if it is an exception entirely outside the date range we are expecting
        # things to work at - if so, throw it away.
        if restrict_date_range_start:
            assert restrict_date_range_start <= restrict_date_range_end
            if restrict_date_range_end < exception.start_of_exceptional_period \
                or exception.end_of_exceptional_period < restrict_date_range_start:
                return

        # test consistency with existing date running exceptions
        for other in self.date_running_exceptions:
            # see if the new one overlaps this other exception
            if not(other.end_of_exceptional_period < exception.start_of_exceptional_period \
                or exception.end_of_exceptional_period < other.start_of_exceptional_period):
                # We're in trouble if it overlapped, and the operation code differed - 
                # this is being conservative. It is possible ATCO-CIF documents what criteria
                # causes one range to override another in this case, in which case amend
                # this and is_valid_on_date below appropriately.
                if other.operation_code != exception.operation_code:
                    raise Exception("Inconsistency between date running exceptions, " + exception.line + " and " + other.line)

        # store the new date running exception
        self.date_running_exceptions.append(exception)

    def is_valid_on_date(self, d):
        '''Given a datetime.date returns a pair of True or False according to
        whether the journey runs on that date, and the reasoning.

        >>> jh = JourneyHeader('QSNGW    6B3920070521200712071111100  2B82P10553TRAIN           I', 1)
        >>> jh.is_valid_on_date(datetime.date(2007, 5, 21))
        BoolWithReason(True, 'OK')
        >>> jh.is_valid_on_date(datetime.date(2007, 5, 20))
        BoolWithReason(False, '2007-05-20 not in range of date of operation 2007-05-21 - 2007-12-07')
        >>> jh.is_valid_on_date(datetime.date(2007, 5, 26))
        BoolWithReason(False, "journey doesn't operate on a Saturday")

        You can add exceptions to the date range, see JourneyDateRunning below for examples.
        '''

        # optimisaton if this called multiple times with same date
        if d != self.cache_valid_date:
            self.cache_valid = self._internal_is_valid_on_date(d)
            self.cache_valid_date = d

        return self.cache_valid

    def _internal_is_valid_on_date(self, d):
        # add_date_running_exception above tests that the exception date ranges
        # are consistent with each other, so this naive implementation that
        # assumes no kind of nesting will do.
        excepted_state = None
        for exception in self.date_running_exceptions:
            if exception.start_of_exceptional_period <= d and d <= exception.end_of_exceptional_period:
                excepted_state = exception.operation_code
        if excepted_state == False:
            return BoolWithReason(False, "%s not in range of exceptional date records" % (str(d)))
        if excepted_state == None:
            if not self.first_date_of_operation <= d and d <= self.last_date_of_operation:
                return BoolWithReason(False, "%s not in range of date of operation %s - %s" % (str(d), str(self.first_date_of_operation), str(self.last_date_of_operation)))

        # check runs on this day of week
        if not self.operates_on_day_of_week[d.isoweekday()]:
            return BoolWithReason(False, "journey doesn't operate on a " + d.strftime('%A'))

        if not self.assume_no_holidays:
            # NPTDR provides data only for days when there are no school or bank holidays,
            # so can safely set assume_no_holidays when loading it. For other ATCO-CIF
            # data sets, will need to import lists of holidays for this function to work.

            # school terms
            assert self.school_term_time == " ", "fancy school term related journey not implemented " + self.school_term_time + ", perhaps set assume_no_holidays"

            # bank holidays
            assert self.bank_holidays == " ", "fancy bank holiday related journey not implemented " + self.bank_holidays + ", perhaps set assume_no_holidays"

        return BoolWithReason(True, "OK")

    def add_hop(self, hop):
        '''This associates the start, intermediate and final stops of a journey
        with the journey header.

        >>> jh = JourneyHeader('QSNCH   2933E20071008200712071111100  1H49P80092TRAIN           I', 1)
        >>> jh.add_hop(JourneyOrigin('QO9100PRINRIS 16362  T1  '))
        >>> jh.add_hop(JourneyIntermediate('QI9100SUNDRTN 16401640T   T1  '))
        >>> jh.add_hop(JourneyIntermediate('QI9100HWYCOMB 16471647T3  T1  '))
        >>> jh.add_hop(JourneyIntermediate('QI9100BCNSFLD 16531653T   T1  '))
        >>> jh.add_hop(JourneyIntermediate('QI9100GERRDSX 16591659T   T1  '))
        >>> jh.add_hop(JourneyDestination('QT9100MARYLBN 17286  T1  '))

        There are then some other functions you can call.

        >>> jh.find_arrival_times_at_location('9100BCNSFLD')
        [datetime.time(16, 53)]
        >>> print jh.find_arrival_times_at_location('9100PRINRIS')
        []
        >>> print jh.find_arrival_times_at_location('somewhere else')
        []
        >>> jh.find_departure_times_at_location('9100SUNDRTN')
        [datetime.time(16, 40)]
        >>> print jh.find_departure_times_at_location('9100MARYLBN')
        []
        '''

        if hop.line in self.hop_lines:
            # if we go to the same stop at the same time again, ignore duplicate
            logging.debug("removed duplicate stop/time " + hop.line)
            return
        #if hop.location in self.hop_locations:
        #    print "duplicate stop %s %s" % (hop.location, hop.line)
        assert isinstance(hop, JourneyOrigin) or isinstance(hop, JourneyIntermediate) or isinstance(hop, JourneyDestination)
        self.hops.append(hop)
        self.hop_lines[hop.line] = True
        #self.hop_locations[hop.location] = True

    def find_arrival_times_at_location(self, location):
        ''' Given a location (as a string short code), return the times this journey
        stops there, or [] if it only starts there, or doesn't stop there.
            
        See add_hop above for examples.
        '''
        ret = []
        for hop in self.hops:
            if hop.location == location:
                if hop.is_set_down():
                    ret.append(hop.published_arrival_time)

        return ret

    def find_departure_times_at_location(self, location):
        ''' Given a location (as a string short code), return the times this journey
        starts there, or [] if it only stops there, or doesn't start there.
            
        See add_hop above for examples.
        '''
        ret = []
        for hop in self.hops:
            if hop.location == location:
                if hop.is_pick_up():
                    ret.append(hop.published_departure_time)

        return ret

    def crosses_midnight(self):
        ''' Returns whether the journey takes place across midnight. '''
        previous_departure_time = datetime.time(0, 0, 0)
        for hop in self.hops:
            if hop.is_pick_up():
                if previous_departure_time > hop.published_departure_time:
                    return True
                previous_departure_time = hop.published_departure_time
        return False

    def vehicle_code(self, atco):
        ''' Returns the single character code for the vehicle type. Uses its
        file_loading_number as the self.vehicle_type variable is specific to
        the file that the data came from. i.e. The same codes are used for
        different types of transport. '''
        vehicle_code = atco.vehicle_type_to_code[self.file_loading_number][self.vehicle_type]
        return vehicle_code 


class JourneyDateRunning(CIFRecord):
    '''Optionally follows a JourneyHeader. The header itself has only one simple
    date range for when a journey runs. This record creates exceptions from
    that range for when the journey does or does not run. 

    Here is a normal journey, which runs on Christmas day.

    >>> jh = JourneyHeader('QSNSUC   599B20070910204912311111100  X5        COACH           5', 1)
    >>> jh.is_valid_on_date(datetime.date(2007,12,25)) # Christmas day
    BoolWithReason(True, 'OK')

    Here we add an exception to make it not run on Christmas day. Note that we
    construct the whole journey again, as it does internal caching if you call
    it repeatedly with the same date. i.e. It expects you to load the whole
    journey with exceptions in before using it rather than modify it during use.

    >>> jh = JourneyHeader('QSNSUC   599B20070910204912311111100  X5        COACH           5', 1)
    >>> jdr = JourneyDateRunning('QE20071225200712250')
    >>> (jdr.start_of_exceptional_period, jdr.end_of_exceptional_period)
    (datetime.date(2007, 12, 25), datetime.date(2007, 12, 25))
    >>> jdr.operation_code
    False
    >>> len(jh.date_running_exceptions)
    0
    >>> jh.add_date_running_exception(jdr)
    >>> len(jh.date_running_exceptions)
    1
    >>> jh.is_valid_on_date(datetime.date(2007,12,25)) # Christmas day
    BoolWithReason(False, '2007-12-25 not in range of exceptional date records')

    If two JourneyDateRunning records contradict each other, it raises an error.

    >>> jdr2 = JourneyDateRunning('QE20071225200712301')
    >>> jh.add_date_running_exception(jdr2) # inconsistent, as overlaps and has different operation code
    Traceback (most recent call last):
        ...
    Exception: Inconsistency between date running exceptions, QE20071225200712301 and QE20071225200712250

    Unless you tell it to ignore date ranges where you don't expect data to
    work, in which case it won't even add the date range exception if it is
    entirely outside the working range.

    >>> len(jh.date_running_exceptions)
    1
    >>> jh.add_date_running_exception(jdr2, datetime.date(2007,1,1), datetime.date(2007,2,1)) 
    >>> len(jh.date_running_exceptions)
    1

    >>> jdr3 = JourneyDateRunning('QE20071225200712300')
    >>> jh.add_date_running_exception(jdr3) # not inconsistent, as has same operation_code
    >>> jdr4 = JourneyDateRunning('QE20071220200712241')
    >>> jh.add_date_running_exception(jdr4) # not inconsistent, as date range doesn't overlap
    '''

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QE")

        matches = re.match('^QE(\d{8})(\d{8})([01])$', line)
        if not matches:
            raise Exception("Journey origin line incorrectly formatted: " + line)

        self.start_of_exceptional_period = parse_date(matches.group(1))
        self.end_of_exceptional_period = parse_date(matches.group(2))
        self.operation_code = bool(int(matches.group(3)))

class JourneyOrigin(CIFRecord):
    '''Start of a journey route.

    >>> jo = JourneyOrigin('QO9100MDNHEAD 09375B T1  ')
    >>> jo.location
    '9100MDNHEAD'
    >>> jo.published_departure_time
    datetime.time(9, 37)
    >>> jo.bay_number
    '5B'
    >>> jo.timing_point_indicator
    True
    >>> print jo.fare_stage_indicator # '  ' isn't in the spec for this, but occurs in wild, so we return None for it
    None

    There are some additional functions compatible with those in JourneyIntermediate.
    >>> jo.is_set_down()
    False
    >>> jo.is_pick_up()
    True
    '''

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QO")

        matches = re.match('^QO(.{12})(\d{4})(.{3})(T[01])(F0|F1|  ) ?$', line)
        if not matches:
            raise Exception("Journey origin line incorrectly formatted: " + line)

        self.location = canonicalise_location(matches.group(1))
        self.published_departure_time = parse_time(matches.group(2))
        self.bay_number = matches.group(3).strip()
        self.timing_point_indicator = { 'T0' : False, 'T1' : True }[matches.group(4)]
        self.fare_stage_indicator = { 'F0' : False, 'F1' : True, '  ' : None }[matches.group(5)]

    def is_set_down(self):
        return False

    def is_pick_up(self):
        return True
    
class JourneyIntermediate(CIFRecord):
    '''Intermediate stop on a journey.

    >>> ji = JourneyIntermediate('QI9100FURZEP  09410941T   T1  ')
    >>> ji.location
    '9100FURZEP'
    >>> ji.published_arrival_time
    datetime.time(9, 41)
    >>> ji.published_departure_time
    datetime.time(9, 41)
    >>> ji.activity_flag # T isn't a documented value, but seen in wild, see below
    'T'
    >>> ji.bay_number
    ''
    >>> ji.timing_point_indicator
    True
    >>> print ji.fare_stage_indicator # '  ' isn't in the spec for this, but occurs in wild, so we return None for it
    None

    These functions tell you if the vehicle lets passengers off or allows
    passengers on at the stop. They interpret the activity_flag, 
    >>> ji.is_set_down()
    True
    >>> ji.is_pick_up()
    True
    '''

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QI")

        # BPSN are documented values for activity_flag in CIF file, other train ones are documented
        # in http://www.atoc.org/rsp/_downloads/RJIS/20040601.pdf
        matches = re.match('^QI(.{12})(\d{4})(\d{4})([BPSNACDORTUKXL -])(.{3})(T[01])(F0|F1|  )$', line)
        if not matches:
            raise Exception("Journey intermediate line incorrectly formatted: " + line)

        self.location = canonicalise_location(matches.group(1))
        self.published_arrival_time = parse_time(matches.group(2))
        self.published_departure_time = parse_time(matches.group(3))
        self.activity_flag = matches.group(4)
        self.bay_number = matches.group(5).strip()
        self.timing_point_indicator = { 'T0' : False, 'T1' : True }[matches.group(6)]
        self.fare_stage_indicator = { 'F0' : False, 'F1' : True, '  ' : None }[matches.group(7)]

        # We think O means no stop for trains, and all such entries have no time marked
        if self.activity_flag == 'O':
            assert self.published_arrival_time == datetime.time(0, 0, 0) and self.published_departure_time == datetime.time(0, 0, 0)
        # D is the same as S - Set Down only. Always has 0000 for departure time.
        # Let us assume departure time = arrival.
        if self.activity_flag == 'D':
            assert self.published_departure_time == datetime.time(0, 0, 0)
            assert self.published_arrival_time != datetime.time(0, 0, 0)
            self.published_departure_time = self.published_arrival_time
        # U appears to be the opposite, same as P (Pick Up only).
        if self.activity_flag == 'U':
            assert self.published_departure_time != datetime.time(0, 0, 0)
            assert self.published_arrival_time == datetime.time(0, 0, 0)
            self.published_arrival_time = self.published_departure_time

    # B - Both pick up and set down
    # P - Pick up only
    # S - Set down only
    # N - Neither pick up nor set down
    # A - stop/shunt to Allow other trains to pass
    # C - stop to Change trainmen
    # D - set Down only (train)
    # O - train stop for Other operating reasons (so same as N)
    # R - Request stop
    # T - both pick up and set down (Train)
    # U - pick Up only (train)
    # X - pass another train at Xing point on single line
    # L - Undocumented
    # K - Undocumented
    # [space] - Undocumented
    # - - stop to attach/detach vehicles
    def is_set_down(self):
        if self.activity_flag in ['B', 'S', 'T', 'D', 'R']:
            return True
        if self.activity_flag in ['N', 'P', 'O', 'U', 'A', 'C', 'X', '-', 'L', 'K', ' ']:
            return False
        assert False, "activity_flag %s not supported (location %s) " % (self.activity_flag, self.location)
    def is_pick_up(self):
        if self.activity_flag in ['B', 'P', 'T', 'U', 'R']:
            return True
        if self.activity_flag in ['N', 'S', 'O', 'D', 'A', 'C', 'X', '-', 'L', 'K', ' ']:
            return False
        assert False, "activity_flag %s not supported (location %s)" % (self.activity_flag, self.location)


class JourneyDestination(CIFRecord):
    '''End of a journey route.

    >>> jd = JourneyDestination('QT9100MARLOW  0959   T1  ')
    >>> jd.location
    '9100MARLOW'
    >>> jd.published_arrival_time
    datetime.time(9, 59)
    >>> jd.bay_number
    ''
    >>> jd.timing_point_indicator
    True
    >>> print jd.fare_stage_indicator # '  ' isn't in the spec for this, but occurs in wild, so we return None for it
    None

    There are some additional functions compatible with those in JourneyIntermediate.
    >>> jd.is_set_down()
    True
    >>> jd.is_pick_up()
    False
    '''

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QT")

        matches = re.match('^QT(.{12})(\d{4})(.{3})(T[01])(F0|F1|  )$', line)
        if not matches:
            raise Exception("Journey destination line incorrectly formatted: " + line)

        self.location = canonicalise_location(matches.group(1))
        self.published_arrival_time = parse_time(matches.group(2))
        self.bay_number = matches.group(3).strip()
        self.timing_point_indicator = { 'T0' : False, 'T1' : True }[matches.group(4)]
        self.fare_stage_indicator = { 'F0' : False, 'F1' : True, '  ' : None }[matches.group(5)]

    def is_set_down(self):
        return True

    def is_pick_up(self):
        return False

###########################################################
# Location record classes
 
class Location(CIFRecord):
    '''Further details about a location. 

    >>> l = Location('QLN9100CHLFNAL Chalfont and Latimer Rail Station                RE0044056')
    >>> l.transaction_type
    'N'
    >>> l.location
    '9100CHLFNAL'
    >>> l.full_location 
    'Chalfont and Latimer Rail Station'
    >>> l.gazetteer_code 
    ' '
    >>> l.point_type # bay / stop / paired stop etc.
    'R'
    >>> l.national_gazetteer_id
    'E0044056'

    It stores associated additional records as well.
    >>> la = LocationAdditional('QBN9100CHLFNAL 499647  197573  Chiltern                                        ')
    >>> l.add_additional(la)
    >>> l.additional.grid_reference_easting
    499647
    
    There is a long description of the location, which includes useful fields
    from the additional record.
    >>> l.long_description()
    'Chalfont and Latimer Rail Station, Chiltern'
    '''

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QL")

        matches = re.match('^QL([NDR])(.{12})(.{48})(.)([BSPRID ])(.{8})$', line)
        if not matches:
            raise Exception("Location line incorrectly formatted: " + line)

        self.transaction_type = matches.group(1)
        assert self.transaction_type == 'N' # code doesn't handle other types yet
        self.location = canonicalise_location(matches.group(2))
        self.full_location = matches.group(3).strip()
        self.gazetteer_code = matches.group(4)
        self.point_type = matches.group(5)
        self.national_gazetteer_id = matches.group(6)
        self.additional = None

    def __str__(self):
        ret = CIFRecord.__str__(self) + "\n"
        if self.additional: 
            ret = ret + "\t" + str(self.additional)
        return ret

    def __repr__(self):
        return "Location('" + self.location + "')"

    def add_additional(self, additional):
        assert isinstance(additional, LocationAdditional)
        assert additional.location == self.location
        self.additional = additional

    def long_description(self):
        ret = self.full_location
        if self.additional:
            if len(self.additional.town_name) > 0:
                ret += ", " + self.additional.town_name 
            if len(self.additional.district_name) > 0:
                ret += ", " + self.additional.district_name
        return ret
        
class LocationAdditional(CIFRecord):
    ''' Additional information on journey route, automatically attached to associated Location.

    >>> la = LocationAdditional('QBN9100CHLFNAL 499647  197573  Chiltern                                        ')
    >>> la.transaction_type
    'N'
    >>> la.location
    '9100CHLFNAL'
    >>> la.grid_reference_easting
    499647
    >>> la.grid_reference_northing
    197573
    >>> la.district_name
    'Chiltern'
    >>> la.town_name
    ''

    If the grid references are not present, they get set to -1.

    >>> la2 = LocationAdditional('QBN000000023750                Caythorpe                                       ' )
    >>> la2.grid_reference_easting
    -1
    >>> la2.grid_reference_northing
    -1
    '''

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QB")

        matches = re.match('^QB([NDR])(.{12})(.{8})(.{8})(.{24})(.{24})$', line)
        if not matches:
            raise Exception("Location additional line incorrectly formatted: " + line)

        self.transaction_type = matches.group(1)
        self.location = canonicalise_location(matches.group(2))
        easting = matches.group(3).strip()
        northing = matches.group(4).strip()
        self.grid_reference_easting = easting and int(easting) or -1
        self.grid_reference_northing = northing and int(northing) or -1
        self.district_name = matches.group(5).strip()
        self.town_name = matches.group(6).strip()

###########################################################
# Vehicle type classes
 
class VehicleType(CIFRecord):
    '''Types of vehicles.

    >>> l = VehicleType('QVNLFBUS   Bus                     ')
    >>> l.vehicle_type
    'LFBUS'
    >>> l.vehicle_long_type
    'Bus'
    >>> l.type_code()
    'B'

    >>> l2 = VehicleType('QVNFerry   Ferry/River Bus         ')
    >>> l2.vehicle_type
    'FERRY'
    >>> l2.vehicle_long_type
    'Ferry/River Bus'
    >>> l2.type_code()
    'F'
    '''

    types = { 'Bus' : 'B', 
              'Coach' : 'C', 
              'Ferry' : 'F', 
              'Ferry/River Bus' : 'F', 
              'Metro' : 'M', 
              'Heavy Rail' : 'T', 
              'Air' : 'A' }

    def __init__(self, line):
        CIFRecord.__init__(self, line, "QV")

        matches = re.match('^QV([NDR])(.{8})(.{24})$', line)
        if not matches:
            raise Exception("Vehicle type line incorrectly formatted: " + line)

        self.transaction_type = matches.group(1)
        assert self.transaction_type == 'N' # code doesn't handle other types yet
        self.vehicle_type = matches.group(2).strip().upper()
        self.vehicle_long_type = matches.group(3).strip()
        assert self.vehicle_long_type in VehicleType.types

    def type_code(self):
        return VehicleType.types[self.vehicle_long_type]

###########################################################

# Run tests if this module is executed directly. Recommended you use nosetests
# with doctest enabled to run tests found in lots of modules.
if __name__ == "__main__":
    import doctest
    doctest.testmod()

