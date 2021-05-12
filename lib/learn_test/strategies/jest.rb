# frozen_string_literal: true

module LearnTest
  module Strategies
    class Jest < LearnTest::Strategy
      include LearnTest::JsStrategy

      def service_endpoint
        '/e/flatiron_mocha'
      end

      def detect
        return false unless js_package

        has_js_dependency?(:jest) || has_js_dependency?(:'react-scripts')
      end

      def check_dependencies
        Dependencies::NodeJS.new.execute
      end

      def run
        run_jest
      end

      def cleanup
        FileUtils.rm('.results.json') if File.exist?('.results.json')
      end

      def push_results?
        true
      end

      def results
        @results ||= {
          username: username,
          github_user_id: user_id,
          learn_oauth_token: learn_oauth_token,
          repo_name: runner.repo,
          build: {
            test_suite: [{
              framework: 'jest',
              formatted_output: output,
              duration: output[:stats]
            }]
          },
          examples: output[:stats][:tests],
          passing_count: output[:stats][:passes],
          failure_count: output[:stats][:failures]
        }
      end

      def output
        @output ||= File.exist?('.results.json') ? Oj.load(File.read('.results.json'), symbol_keys: true) : nil
      end

      private

      def run_jest
        npm_install

        command = if (js_package[:scripts] && js_package[:scripts][:test] || '').include?('@learn-co-curriculum/jest-learn-reporter')
                    'npm test'
                  else
                    install_jest_learn_reporter
                    'node_modules/.bin/jest --reporters=@learn-co-curriculum/jest-learn-reporter --reporters=default --watchAll'
                  end

        system(command)
      end

      def install_jest_learn_reporter
        return if File.exist?('node_modules/@learn-co-curriculum/jest-learn-reporter')

        run_install('npm install @learn-co-curriculum/jest-learn-reporter', npm_install: true)
      end
    end
  end
end
