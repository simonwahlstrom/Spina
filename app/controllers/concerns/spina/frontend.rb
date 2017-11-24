module Spina
  module Frontend
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, with: :redirect_or_render_404
      
      before_action :set_locale
    end

    def show
      if should_skip_to_first_child?
        redirect_to first_live_child.try(:materialized_path) and return
      elsif page.link_url.present?
        redirect_to page.link_url and return
      end

      render_with_template(page)
    end

    private

      def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
      end

      def page_by_locale(locale)
        Page.with_translations(locale).find_by!(materialized_path: spina_request_path)
      end

      def page
        current_page = page_by_locale(I18n.locale) || page_by_locale(I18n.default_locale)
        @page ||= (action_name == 'homepage') ? Page.find_by!(name: 'homepage') : current_page
      end

      def spina_request_path
        segments = ['/', params[:locale], params[:id]].compact
        File.join(*segments)
      end

      def should_skip_to_first_child?
        page.skip_to_first_child && first_live_child
      end

      def first_live_child
        page.children.sorted.live.first
      end

      def redirect_or_render_404
        if rule = RewriteRule.find_by(old_path: spina_request_path)
          redirect_to rule.new_path, status: :moved_permanently
        else
          render_404
        end
      end

      def render_404
        render file: "#{Rails.root}/public/404.html", status: 404
      end

      def render_with_template(page)
        render layout: "application", template: "content/#{page.view_template || 'show'}"
      end

  end
end
