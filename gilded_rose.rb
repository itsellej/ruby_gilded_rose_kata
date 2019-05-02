def update_quality(items)
  items.each do |item|

    if 'Aged Brie'.include?(item.name)
      updater = AgedBrieQualityUpdater.new
    else
      updater = GeneralQualityUpdater.new
    end

    updater.update_item(item)
  end
end

class GeneralQualityUpdater
  def update_item(item)
    update_quality(item)
    update_sell_in(item)
  end

  private

  def update_quality(item)
    if item.sell_in <= 0
      item.quality -= 2
    else
      item.quality -= 1
    end

    validate_quality_level(item)
  end

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def validate_quality_level(item)
    item.quality = 0 if item.quality < 0
    item.quality = 50 if item.quality > 50
    item.quality
  end
end

class AgedBrieQualityUpdater < GeneralQualityUpdater
  def update_quality(item)
    if item.sell_in <= 0
      item.quality += 2
    else
      item.quality += 1
    end

    validate_quality_level(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
