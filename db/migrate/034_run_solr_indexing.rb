class RunSolrIndexing < ActiveRecord::Migration[4.2] # 2.0
  def self.up
    # Not using SOLR yet after all
    #PublicBody.rebuild_solr_index
  end

  def self.down
  end
end
