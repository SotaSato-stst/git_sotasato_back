prefecture.nil? ? json.null! : json.call(prefecture, :id, :name, :logo_url)
