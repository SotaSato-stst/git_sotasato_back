module SupplierConcern
  extend ActiveSupport::Concern

  included do
    scope :has_url_domain, -> { where('url_domain != ?', '') }

    class << self
      def index_by_url_domain
        has_url_domain.map { |r| { r.url_domain => r.id } }.inject(&:merge) || {}
      end
    end
  end
end
