class InfoRequest
  module Prominence
    class EmbargoExpiringQuery
      def initialize(relation = InfoRequest)
        @relation = relation
      end

      def call
        @relation.includes(:embargo)
          .where('embargoes.id IS NOT NULL')
            .where("embargoes.publish_at <= ?", AlaveteliPro::Embargo.expiring_soon_time)
              .references(:embargoes)
      end
    end
  end
end
