#!/usr/bin/env python3

from collections import Counter

materials = {}
lengths = Counter()


def digits(string):
    if 'x' in string:
        return [[digits(tup) for tup in string.split('x')]]
    numbers = list('0123456789.')
    ret = []
    for c in string:
        if c in numbers:
            ret.append(c)
        else:
            break
    if '.' in ret:
        return float(''.join(ret))
    else:
        return int(''.join(ret))

def materials_assemble(list_materials):
    ret_dict = {}
    for key, _, _ in list_materials:
        value = materials[key]
        try:
            value = sum([(val[0]/100)*(val[1]/100) for val in value])
            ret_dict[key] = value
        except TypeError:
            ret_dict[key] = value/100
    return ret_dict


recipe_table = [
    ('Board',       (1220/1000)*(2440/1000),129),
    ('Lath',        4.2,                    16.59),
    ('Oak board',   2.4,                    319),
    ('Oak leg',     2.4,                    299),
    ('Oak border',  2.44,                   109),
    ('Mosaic',      0.33*0.302,             44.95),
]


def recipe_to_dict(recipe):
    ret_dict = {}
    for key, quantity, price in recipe:
        ret_dict[key] = mat_dict = {}
        mat_dict['quantity'] = quantity
        mat_dict['price'] = price
    return ret_dict

def pick(recipe, print_info=False):
    num_needed = {}
    materials = materials_assemble(recipe)
    quantity = recipe_to_dict(recipe)
    for key, ammount in materials.items():
        if not num_needed.get(key):
            num_needed[key] = 0
        mat_quantity = quantity[key]['quantity']
        fully_consumed = (int)(ammount/mat_quantity)
        last_materials = ammount%mat_quantity
        partially_left = mat_quantity - last_materials
        partially_consumed = int(last_materials > 0)
        if (print_info):
            print("{}:".format(key))
            print("  Available as: {}".format(mat_quantity))
            print("  Amount needed: {}".format(ammount))
            print("  Consumed:")
            print("    Fully: {}".format(fully_consumed))
            fmt_partially = \
                  "    Partially: {} (Left: {:.2f} or {:.2f}%)"
            print(fmt_partially.format(partially_consumed,
                                       partially_left,
                                       partially_left/mat_quantity*100))
            print("  Total: {}".format(fully_consumed+partially_consumed))
            print("--- ")

        num_needed[key] += fully_consumed + partially_consumed
    return num_needed

def saw_materials(counter_dict, recipe, verbose=False):
    recipe_dict = recipe_to_dict(recipe)
    materials = materials_assemble(recipe)
    num_needed = {}
    for name, counter in counter_dict.items():
        quantity = recipe_dict[name]['quantity']
        num_needed[name] = 0
        if verbose:
            print("{}:".format(name))
        current_total = 0
        for length, number in counter.items():
            try:
                length = sum([dig[0]*dig[1] for dig in digits(length)])
                length /= 1e2
            except:
                pass
            length /= 100
            for _ in range(0, number):
                if verbose:
                    fmt_current = "   Current total {}/{}, trying to take {}."
                    print(fmt_current.format(current_total, quantity, length))
                if current_total + length > quantity:
                    num_needed[name] += 1
                    current_total = length
                    if verbose:
                        print("    Could not take {}, new total: {}".format(
                            length, current_total))
                else:
                    current_total += length
        num_needed[name] += 1 if current_total > 0 else 0
    print("From sawing: ")
    for key, _, _ in recipe:
        print("  {}: {}".format(key, num_needed[key]))
    return num_needed

def print_price(num_material, picked, recipe):
    recipe_dict = recipe_to_dict(recipe)
    total_price = 0
    print("Price:")
    for key, num in num_material.items():
        num = max(num, picked[key])
        price = recipe_dict[key]['price']
        price_mul = price*num
        print("   {}:- á {}st = {}:-".format(price, num, price_mul))
        total_price += price_mul
    print("---")
    print("Total: {}:-".format(total_price))


def main():

    file="bom.txt"

    keys_table = [tup[0] for tup in recipe_table]
    lengths_table = {}

    for line in [line.strip()[7:-1] for line in open(file).readlines()]:
        name, value = [tok.strip() for tok in line.split('--')]
        if (name == "frame"):
            lengths[value] += 1
        elif (name in keys_table):
            count = lengths_table.get(name)
            if not lengths_table.get(name):
                lengths_table[name] = count = Counter()
            try:
                count[digits(value)] += 1
            except TypeError:
                count[value] += 1
        if not materials.get(name):
            materials[name] = digits(value)
        else:
            materials[name] += digits(value)
    materials['Mosaic'] = materials['Board'][:1]
    mosaic_count = lengths_table['Mosaic'] = Counter()
    dim_mosaic = sum([(a[0]/100)*(a[1]/100) for a in materials['Mosaic']])
    mosaic_qual = recipe_to_dict(recipe_table)['Mosaic']['quantity']
    mosaic_count[mosaic_qual] += int(dim_mosaic/mosaic_qual)
    mosaic_count[mosaic_qual] += 2

    frame_metal = 79.5;
    #frame_wood = 88.17 / int(180/42);
    frame_wood = 8.95; # Tryckimpgnernerad.
    #frame_wood = 7.95; # Ej Tryckimpegnerad.
    #frame_wood = 14.10; # Ej Tryckimpegnerad Bejjer.

    prices = {
        'frame': frame_wood,
        'stoppning_kudde': 125, # kr/st.
        'stoppning_kudde_bak': 125.0/4.0, #kr/st.
        'tyg_kuddar': 139, #kr/m. (160cm bred)
    }

    grand_total = 0

    # Pipe.
    total_frame = materials['frame']
    total_meter_frame = total_frame/100
    cost_frame = total_meter_frame*prices['frame']
    grand_total += cost_frame


    print("Total frame {}cm -> {}m á {}/m --> Cost: \
    {}kr -- {}kr".format(total_frame, total_meter_frame, prices['frame'], cost_frame,
                 round(cost_frame, 1)))

    # Cloth.
    total_cloth = 0

    for key, value in materials.items():
        if "pillow" in key:
            total_cloth += value

    total_cloth_m2 = total_cloth/1e4
    cloth_width = 1.6 #m
    cloth_length_needed = total_cloth_m2/cloth_width
    cost_cloth = cloth_length_needed*prices['tyg_kuddar']
    grand_total += cost_cloth
    print("Total cloth {}cm^2 -> {}m^2 á 139kr/m (160cm wide), need {}m --> {}kr \
    --> {}kr".format(total_cloth, total_cloth_m2, cloth_length_needed, cost_cloth,
                   round(cost_cloth, 2)))

    # Stuffing main.
    num_pillows = 8
    cost_pillow_filling = num_pillows*prices['stoppning_kudde']
    print("Stuffing main pillows 125kr/pillow á {} pillows: {}kr -->\
     {}kr.".format(num_pillows, cost_pillow_filling, round(cost_pillow_filling, 2)))
    grand_total += cost_pillow_filling

    # Stuffing back.
    num_back_pillows = 9
    cost_pillow_back_filling = num_back_pillows*prices['stoppning_kudde_bak']
    print("Stuffing back pillows {}kr/pillow á {} pillows: {}kr -->\
     {}kr.".format(prices['stoppning_kudde_bak'], num_back_pillows,
                   cost_pillow_back_filling, round(cost_pillow_back_filling, 2)))
    grand_total += cost_pillow_back_filling

    print("--------\nTotal: {}kr.".format(round(grand_total, 2)))

    print("\nLength summery:")
    for v, l in reversed(sorted([(v, l) for l, v in lengths.items()])):
        print("{:<3}x {}".format(v, l))

    max_len = 420/2
    current_len = 0
    num_max = 0

    for l, n in lengths.items():
        l = digits(l)
        for _ in range(n):
    #        print("Current total: {} Trying to add: {}". format(current_len, l))
            current_len += l
            if current_len > max_len:
    #            print("not using: {}".format(max_len-(current_len-l)))
                num_max += 1
                current_len = l

    print("Need {} x of {}cm.".format(num_max, max_len))

    materials_picked_table = pick(recipe_table, True)
#    # Add 1 extra board.
#    materials_picked_table['Board'] += 1

    #saw_materials(lengths_table, recipe_table, True)
    num_sawed = saw_materials(lengths_table, recipe_table)
    print_price(num_sawed, materials_picked_table, recipe_table)


if __name__ == "__main__":
    main()
