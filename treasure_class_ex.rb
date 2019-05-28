# Treasure Class  group   level   Picks   Unique  Set     Rare    Magic   NoDrop  Item1   Prob1   Item2   Prob2   Item3   Prob3   Item4   Prob4   Item5   Prob5       Item6   Prob6   Item7   Prob7   Item8   Prob8   Item9   Prob9   Item10  Prob10  SumItems        TotalProb       DropChance      Term
# Gold                    1                                               gld     1                                                                          0
# Jewelry A                       1                                               rin     8       amu     4       jew     2       cm3     2       cm2     2  cm1      2                                                                                               0
# Jewelry B                       1                                               rin     8       amu     4       jew     2       cm3     2       cm2     2  cm1      2                                                                                               0
# Jewelry C                       1                                               rin     8       amu     4       jew     2       cm3     2       cm2     2  cm1      2                                                                                               0
# Chipped Gem                     1                                               gcv     3       gcy     3       gcb     3       gcg     3       gcr     3  gcw      3       skc     2                                                                               0
# Flawed Gem                      1                                               gfv     3       gfy     3       gfb     3       gfg     3       gfr     3  gfw      3       skf     2                                                                               0
# Normal Gem                      1                                               gsv     3       gsy     3       gsb     3       gsg     3       gsr     3  gsw      3       sku     2                                                                               0
# Flawless Gem                    1                                               gzv     3       gly     3       glb     3       glg     3       glr     3  glw      3       skl     2                                                                               0
# Perfect Gem                     1                                               gpv     3       gpy     3       gpb     3       gpg     3       gpr     3  gpw      3       skz     2          

# SuperUniques.txt
# MonStats.txt
#
# All the lines endind by x seems useless


# https://d2mods.info/forum/viewtopic.php?t=19359
# https://forums.d2jsp.org/topic.php?t=31211678
# https://forums.d2jsp.org/topic.php?t=24046916&f=87


class TreasureClass
  attr_reader :id

  attr_accessor :items

  attr_accessor :picks

  attr_accessor :group
  attr_accessor :level

  attr_accessor :rarity
  attr_accessor :no_drop

  # Not used
  attr_reader :sum_items
  attr_reader :total_prob
  attr_reader :drop_chance

  def initialize(attributes)
    @id = attributes["Treasure Class"]
    @items = []
    1.upto(10) do |i|
      next if attributes["Item#{i}"].nil?
      item = TreasureClassItem.new(attributes["Item#{i}"], attributes["Prob#{i}"])
      items << item
    end
    @rarity = {
      "Unique" => attributes["Unique"],
      "Set" => attributes["Set"],
      "Rare" => attributes["Rare"],
      "Magic" => attributes["Magic"],
    }
    @no_drop = attributes["NoDrop"]
    @group = attributes["group"]
    @level = attributes["level"]

    @sum_items = attributes["SumItems"]
    @total_prob = attributes["TotalProb"]
    @drop_chance = attributes["DropChance"]

    @picks = attributes["Picks"]
  end
end

class TreasureClassItem
  attr_accessor :item

  # Used as quantity indicator if the picks value is negative
  attr_accessor :prob

  def initialize(item, prob)
    @item = item
    @prob = prob
  end
end

class TreasureClassGroup
  attr_accessor :treasure_classes
  attr_reader :name
  attr_reader :id

  def initialize(id, name)
    @id = id
    @name = name
    @treasure_classes = []
  end

  def variants
    @treasure_classes.map(&:id).uniq
  end
end

require "csv"

treasure_classes = []
csv = CSV.new(File.read("../d2-base-mod/data/global/excel/TreasureClassEx.txt"), col_sep: "\t", headers: true)
csv.each do |row|
  treasure_classes << TreasureClass.new(row.to_h)
end

treasure_classes_groups = []

treasure_classes.each do |treasure_class|
  next unless treasure_class.group
  group = treasure_classes_groups.detect { |g| g.id == treasure_class.group }
  if group.nil?
    group = TreasureClassGroup.new(treasure_class.group, treasure_class.id) if group.nil?
    treasure_classes_groups << group
  end

  group.treasure_classes << treasure_class
end

treasure_classes_groups.each do |treasure_classes_group|
  puts "#{treasure_classes_group.id} - #{treasure_classes_group.name} (#{treasure_classes_group.variants.size})"
end
