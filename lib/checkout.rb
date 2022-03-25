class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices, discounts)
    @prices = prices
    @discounts = discounts
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0

    basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }.each do |item, count|
      total = apply_discounts(total, item, count)
    end

    total
  end

  private

  def basket
    @basket ||= Array.new
  end

  def apply_discounts(total, item, count)
    if @discounts[:buyXgetYfree].key?(item) && count >= @discounts[:buyXgetYfree][item][:qualify]
      discount_params = @discounts[:buyXgetYfree].fetch(item)
      free_items = ((count / discount_params[:qualify]).floor()) * discount_params[:free]
      total += prices.fetch(item) * (count - free_items)
    else
      total += prices.fetch(item) * count
    end
    
    return total
  end
end
