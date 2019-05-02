def update_quality(items)
  items.each do |item|
    updater_type = UpdaterValidator.get_name(item.name)
    updater = UpdaterFactory.select(updater_type)
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

class SulfurasQualityUpdater < GeneralQualityUpdater

  def update_quality(item)
    validate_quality_level(item)
  end

  def update_sell_in(item)
    item.sell_in = item.sell_in
  end

  def validate_quality_level(item)
    item.quality = 80
  end
end

class BackstagePassesQualityUpdater < GeneralQualityUpdater

  def update_quality(item)
    if item.sell_in.between?(6, 10)
      item.quality += 2
    elsif item.sell_in.between?(1, 5)
      item.quality += 3
    elsif item.sell_in <= 0
      item.quality = 0
    else
      item.quality += 1
    end
    validate_quality_level(item)
  end
end

class ConjuredQualityUpdater < GeneralQualityUpdater

  def update_quality(item)
    item.sell_in <= 0 ? item.quality -= 4 : item.quality -= 2
    validate_quality_level(item)
  end
end

class UpdaterFactory
  UPDATER_TYPES = {
    'Aged Brie' => AgedBrieQualityUpdater,
    'Sulfuras' => SulfurasQualityUpdater,
    'Backstage passes' => BackstagePassesQualityUpdater,
    'Conjured' => ConjuredQualityUpdater,
    'Other' => GeneralQualityUpdater
  }.freeze

  def self.select(item_name)
    UPDATER_TYPES[item_name].new
  end
end

class UpdaterValidator
  UPDATER_TYPES =
    ['Aged Brie', 'Sulfuras', 'Backstage passes', 'Conjured'].freeze

  def self.get_name(item_name)
    valid?(item_name) ? get_type(item_name) : 'Other'
  end

  def self.get_type(item_name)
    UPDATER_TYPES.select { |t| item_name.include?(t) }.join
  end

  def self.valid?(item_name)
    UPDATER_TYPES.map { |type| item_name.include?(type) }.include?(true)
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
