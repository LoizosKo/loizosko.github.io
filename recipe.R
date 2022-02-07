begin
#objects //// variables also known as features [categ, numer (cont/discr), ordinal]
#redonion = vegetable, feature-sourness value-sour
#persimmon = fruit, feature-sweetness value-sweet
#fontina cheese = dary, feature-milky value-milk
#vinegar=dressing, feature-sourness value-sour
#ranch dressing = dressing, feature-flavory value-flavor
#pullman bread= baked, feature-floury value-flour
#watermelon radish=fruit, feature-sweetness value-sweet
#almonds=nuts, feature-crunchy value-crunch

# Ingredients:
onion = red_onion(1)
persimmon = persimmon(1)
cheese = shredded_fontina_cheese(4oz)
vinegar = sherry_vinegar(1tbsp) 
ranch = ranch_dressing(3tbsp)
bread = slices_sourdough_pullman_bread(4)
watradish = watermelon_radish(1)
almonds = sliced_roasted_almonds(2tbsp)
oil = olive_oil(2tbsp)
salt = salt(1tbsp)
pepper = pepper(1tbsp)

#PREPARE & COOK THE ONION
#step 1: Preheat your pan
#In a large pan, heat 2 teaspoons of olive oil on medium-high until hot. 
pan = pan (cooked_onion)
ingredient.add(oil)
pan.heat(med-high)

# Step 2: add onion & cook stirring occasionally until 3-4 mins
ingredients.add(onion, salt, pepper)
pan.stir(4 mins)

# Step 3: Add vinegar
ingredients.add(vinegar)
pan.stir(30 secs)

# Step 4: turn off the heat
pan.heat(off)

#PREPARE THE REMAINING INGREDIENTS
# Step 1: Wash and dry the fresh produce
ingredient.wash(produce)
ingredient.dry(produce)

# Step 2: Core the persimmon; halve lengthwise, then thinly slice
ingredient.core(persimmon)
ingredient.halflongwise(persimmon)
ingredient.slice(persimmon)

# Step 3: Roughly chop the lettuce
ingredient.slice(lettuce)

#Step 4: combine the lettuce and sliced radish in a large bowl.
bowl = bowl(ingredient.combine)
ingredient.combine(lettuce, radish)

#ASSEMBLE & COOK THE SANDWICHES
#Step 1: assemble sandwiches using bread, cheese, sliced persimmon, and cooked onion.
sandwiches
sandwiches.base(bread/2)
sandwiches.add(persimmon, cheese, cooked_onion)
sandwiches.peak(bread/2)

#Step 2: Rinse and wipe out the pan used to cook the onion
pan.rinse
pan.wipeout

#step 3: In the same pan heat 1 tbsp of olive oil on medium until hot
pan = pan (cooked_sandwhiches)
ingredient.add(oil/2)
pan.heat(med-high)

#step 4: add the sandwiches, loosely cover the pan with foil and cook for 2 to 4 mins per side
sandwiches.add(2-4mins)
pan.foilcover()
sandwiches.flip(2-4 mins)

#step 5: transfer to a cutting board immediately season with salt. Carefully halve on an angle
cutting_board = cutting_board
sandwiches.cutting_board
ingredient.add(salt)
sandwiches.halfcut

#MAKE THE SALAD AND SERVE YOUR DISH
#Before serving, add the ranch and almonds to the bowl of prepared lettuce and radish.
#season with salt and pepper, toss to coat.
bowl(ingredient.add, season)
ingredient.add(ranch, almonds)
season(salt, pepper)

#taste, then season with salt and pepper if desired
sandwiches.
