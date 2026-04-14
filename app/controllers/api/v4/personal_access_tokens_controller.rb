# frozen_string_literal: true

module API
  module V4
    class PersonalAccessTokensController < ::API::V4::UserBaseController
      before_action :find_token, only: [:show, :rotate, :revoke]
      before_action :validate_scopes!, only: [:create]

      def index
        tokens = current_user.admin? && params[:user_id].present? ?
          PersonalAccessToken.for_user(params[:user_id]) :
          PersonalAccessToken.for_user(current_user)

        tokens = apply_filters(tokens)
        @tokens = paginate(tokens.order(created_at: :desc))
      end

      def show
      end

      def create
        token = current_user.personal_access_tokens.new(create_params)
        token.scopes = Array(params[:scopes])

        if token.save
          @token = token
          render :create, status: :created
        else
          render json: { message: token.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def rotate
        new_token = nil
        ApplicationRecord.transaction do
          new_token = current_user.personal_access_tokens.create!(
            name: @token.name,
            description: @token.description,
            scopes: @token.scopes,
            expires_at: params[:expires_at].presence || 30.days.from_now.to_date
          )
          @token.revoke!
        end

        @token = new_token
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def revoke
        @token.revoke!
        head :no_content
      end

      private

      def find_token
        if params[:id] == 'self'
          @token = access_token
          return not_found! unless @token.is_a?(PersonalAccessToken)
        else
          @token = PersonalAccessToken.find(params[:id])
          return forbidden! unless current_user.admin? || @token.user_id == current_user.id
        end
      rescue ActiveRecord::RecordNotFound
        not_found!
      end

      def apply_filters(tokens)
        tokens = tokens.public_send(params[:state]) if params[:state].in?(%w[active inactive revoked])
        tokens = tokens.search(params[:search]) if params[:search].present?
        tokens = tokens.created_after(params[:created_after]) if params[:created_after].present?
        tokens = tokens.created_before(params[:created_before]) if params[:created_before].present?
        tokens = tokens.expires_after(params[:expires_after]) if params[:expires_after].present?
        tokens = tokens.expires_before(params[:expires_before]) if params[:expires_before].present?
        tokens = tokens.last_used_after(params[:last_used_after]) if params[:last_used_after].present?
        tokens = tokens.last_used_before(params[:last_used_before]) if params[:last_used_before].present?
        tokens
      end

      def create_params
        params.permit(:name, :description, :expires_at)
      end

      def validate_scopes!
        invalid_scopes = Array(params[:scopes]).map(&:to_sym) - PersonalAccessToken::AVAILABLE_SCOPES
        render json: { message: "Invalid scopes: #{invalid_scopes.join(', ')}" }, status: :unprocessable_entity if invalid_scopes.any?
      end
    end
  end
end
