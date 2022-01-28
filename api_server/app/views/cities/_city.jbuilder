city.nil? ? json.null! : json.call(city, :id, :name, :logo_url, :prefecture_id)
