json.call(subsidy, :id, :title, :url)
json.supplier do
  json.partial! 'suppliers/supplier', supplier: subsidy.supplier
end
