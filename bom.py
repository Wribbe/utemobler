#!/usr/bin/env python3

materials = {}

def digits(string):
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

file="bom.txt"
for line in [line.strip()[7:-1] for line in open(file).readlines()]:
    name, value = [tok.strip() for tok in line.split('--')]
    if not materials.get(name):
        materials[name] = 0
    materials[name] += digits(value)

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
