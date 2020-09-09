# frozen_string_literal: true

module LearnTest
  module Strategies
    class None < LearnTest::Strategy
      def service_endpoint
        '/e/flatiron_none'
      end

      def run
        # no-op
      end

      def results
        {
          username: username,
          github_user_id: user_id,
          learn_oauth_token: learn_oauth_token,
          repo_name: runner.repo,
          build: {
            test_suite: [{
              framework: 'none',
              formatted_output: '',
              duration: nil
            }]
          },
          examples: 0,
          passing_count: 0,
          pending_count: 0,
          failure_count: 0,
          failure_descriptions: ''
        }
      end
    end
  end
end
