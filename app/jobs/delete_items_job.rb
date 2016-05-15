class DeleteItemsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Value.delete_all
    Item.delete_all
  end
end
