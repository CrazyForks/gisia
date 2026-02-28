# frozen_string_literal: true

module API
  module V4
    module IssueFilterable
      extend ActiveSupport::Concern

      private

      def apply_filters(scope)
        scope = scope.with_state(params[:state]) if params[:state].present?
        scope = apply_label_filter(scope, params[:labels]) if params[:labels].present?
        scope = scope.with_assignee(params[:assignee_id]) if params[:assignee_id].present?
        scope.ransack(ransack_filter_params).result
      end

      def apply_label_filter(scope, labels_param)
        names = labels_param.split(',').map(&:strip)
        label_ids = label_scope.where(title: names).pluck(:id)
        scope.with_label_ids(label_ids)
      end

      def label_scope
        Label.all
      end

      def ransack_filter_params
        {}.tap do |q|
          q[:author_id_eq] = params[:author_id] if params[:author_id].present?
          q[:iid_in] = Array(params[:iids]) if params[:iids].present?
          q[search_predicate] = params[:search] if params[:search].present?
        end
      end

      def search_predicate
        case params[:in]
        when 'title' then :title_cont
        when 'description' then :description_cont
        else :title_or_description_cont
        end
      end
    end
  end
end
