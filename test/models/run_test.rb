require "test_helper"

class RunnerTest < ActiveSupport::TestCase
  test "#summary_stats" do
    stats = Run.summary_stats[0]
    assert_equal stats.count, 2
    assert_equal stats.fastest, 1024
    assert_equal stats.slowest, 1239
    assert_equal stats.median, 1131.5
    assert_equal stats.mean, 1131.5
    assert_equal stats.stddev, 152.027957955108
    assert_equal stats.avg_age, 49.5
  end
end
