# MethodVisibilityFix Module
#
# This module ensures certain methods are public by being included after all other modules
# that might have private declarations affecting method visibility

module GitTemplate
  module Command
    module MethodVisibilityFix
      def self.included(base)
        base.class_eval do
          # Make sure create_templated_folder is public
          public :create_templated_folder if private_method_defined?(:create_templated_folder)
          # Make sure rerun_template is public
          public :rerun_template if private_method_defined?(:rerun_template)
          # Make sure run_template_part is public
          public :run_template_part if private_method_defined?(:run_template_part)
        end
      end
    end
  end
end