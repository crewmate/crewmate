# # -*- encoding : utf-8 -*-
require 'thinking_sphinx/test'
require 'fileutils'

module SphinxHelpers
  def ts_reindex(rebuild = false)
    # ThinkingSphinx::Test.stop
    # FileUtils.rm_rf ThinkingSphinx::Test.config.searchd_file_path
    # ThinkingSphinx::Test.init
    # ThinkingSphinx::Test.start
    ThinkingSphinx::Test.index

    # Wait for Sphinx to finish loading in the new index files.
    sleep 0.25 until ts_index_finished?

    # seems to be necessary before hitting sphinx
    sleep(2)
  end

  def ts_index_finished?
    # Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}.*')].empty? # For future version > 3.0 of thinking sphinx
    Dir[Rails.root.join(ThinkingSphinx::Test.config.searchd_file_path, '*.{new,tmp}.*')].empty?
  end
end

World(SphinxHelpers)

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init
# Configure and start Sphinx, and automatically
# stop Sphinx at the end of the test suite.
ThinkingSphinx::Test.start_with_autostop

search_enabled = Teambox.config.allow_search

Before('@sphinx') do
  Teambox.config.allow_search = true
  ts_reindex
end

After('@sphinx') do
  Teambox.config.allow_search = search_enabled
end
