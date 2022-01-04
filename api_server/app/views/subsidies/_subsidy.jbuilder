json.call(subsidy, :title, :url)
json.supplier do
  json.partial! 'suppliers/supplier', supplier: subsidy.supplier
end
