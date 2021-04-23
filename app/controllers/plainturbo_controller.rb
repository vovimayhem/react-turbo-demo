class PlainturboController < ApplicationController
  def index
    limit = 5
    item_scope = Item.order(id: :asc)
    item_count = item_scope.count
    offset = params[:offset]&.to_i || 0

    @items = item_scope.limit(limit).offset(offset)
    @prev = offset.positive? ? plain_turbo_example_path(offset: offset - limit) : nil
    @next = (offset + limit) < item_count ? plain_turbo_example_path(offset: offset + limit) : nil
  end
end
