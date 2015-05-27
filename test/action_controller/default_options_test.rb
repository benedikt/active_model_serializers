require 'test_helper'

module ActionController
  module Serialization
    class DefaultOptionsTest < ActionController::TestCase
      class MyController < ActionController::Base
        def render_with_default_options
          @profile = Profile.new({ id: 1, name: 'Name 1', description: 'Description 1', comments: 'Comments 1' })
          render json: @profile
        end

        def render_with_explicit_serializer_options
          @profile = Profile.new({ id: 1, name: 'Name 1', description: 'Description 1', comments: 'Comments 1' })
          render json: @profile, meta: { baz: 'bam' }
        end

        def render_with_explicit_adapter_options
          @profile = Profile.new({ id: 1, name: 'Name 1', description: 'Description 1', comments: 'Comments 1' })
          render json: @profile, adapter: :json
        end

        def default_serializer_options
          { meta: { foo: 'bar' } }
        end

        def default_adapter_options
          { adapter: :json_api }
        end
      end

      tests MyController

      def test_default_serializer_options
        get :render_with_default_options

        expected = {
          data: {
            name: 'Name 1',
            description: 'Description 1',
            id: '1',
            type: 'profiles'
          },
          meta: {
            foo: 'bar'
          }
        }

        assert_equal expected.to_json, response.body
      end

      def test_explicit_serializer_options
        get :render_with_explicit_serializer_options

        expected = {
          data: {
            name: 'Name 1',
            description: 'Description 1',
            id: '1',
            type: 'profiles'
          },
          meta: {
            baz: 'bam'
          }
        }

        assert_equal expected.to_json, response.body
      end

      def test_explicit_serializer_options
        get :render_with_explicit_adapter_options

        expected = {
          name: 'Name 1',
          description: 'Description 1'
        }

        assert_equal expected.to_json, response.body
      end
    end
  end
end