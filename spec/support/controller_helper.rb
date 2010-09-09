# = ControllerHelper
#
# Adds default behavior shared between specs for Controllers.
#
# == Behavior Added
#
# - Sets <tt>controller</tt> as the current <tt>subject</tt>, so that Shoulda's matchers
#   behave as expected.
# - Performs <tt>login(:admin)</tt> before each example so that all examples run without
#   permission issues. Testing related to specific permissions should be done in Cucumber.
module ControllerHelper
  def self.included(base)
    base.class_eval do
      subject { controller }

      before do
        login(:admin)
      end
    end
  end

  # NOTE: Currently unused; just experimenting
  # module SharedExamples
  #   shared_examples_for "GET show" do
  #     let(:resource) { resource_name }

  #     before do
  #       @resource = Factory(resource)
  #       get :show, :id => @resource
  #     end

  #     it { should respond_with(:success) }
  #     it { should assign_to(resource).with(@resource) }
  #     it { should render_template(:show) }
  #   end

  #   shared_examples_for "GET new" do
  #     let(:resource) { resource_name }
  #     let(:model) { model_name }

  #     before do
  #       get :new
  #     end

  #     it { should respond_with(:success) }
  #     it { should assign_to(resource).with_kind_of(model) }
  #     it { should render_template(:new) }
  #   end

  #   private

  #   def resource_name
  #     self.controller.class.to_s.
  #       demodulize.                # Remove any potential "Members::"
  #       underscore.                # Change MembersController to members_controller
  #       gsub(/_controller$/i, ''). # Remove the _controller part
  #       singularize.               # Make it singular
  #       to_sym
  #   end

  #   def model_name
  #     self.controller.class.to_s.
  #       demodulize.
  #       gsub(/Controller$/, '').
  #       singularize.
  #       constantize
  #   end

  #   def collection_name
  #     resource_name.to_s.pluralize.to_sym
  #   end
  # end
end
