class AddFullUrlToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :full_url, :string
  end
end
