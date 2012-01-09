# Исключающее или
vsim work.basic_xor
add wave sim:/basic_xor/*
force -freeze sim:/basic_xor/vdd 1 0
force -freeze sim:/basic_xor/vss 0 0
force -freeze sim:/basic_xor/in_1 0 0, 1 {250 ps} -r 500
force -freeze sim:/basic_xor/in_2 0 0, 1 {500 ps} -r 1000
run

# ИЛИ-НЕ 3 входа
vsim work.basic_ornot3
add wave sim:/basic_ornot3/*
force -freeze sim:/basic_ornot3/vdd 1 0
force -freeze sim:/basic_ornot3/vss 0 0
force -freeze sim:/basic_ornot3/in_1 0 0, 1 {250 ps} -r 500
force -freeze sim:/basic_ornot3/in_2 0 0, 1 {500 ps} -r 1000
force -freeze sim:/basic_ornot3/in_3 0 0, 1 {1000 ps} -r 2000
run

# И-Не 3 входа
vsim work.basic_andnot3
add wave sim:/basic_andnot3/*
force -freeze sim:/basic_andnot3/vdd 1 0
force -freeze sim:/basic_andnot3/vss 0 0
force -freeze sim:/basic_andnot3/in_1 0 0, 1 {250 ps} -r 500
force -freeze sim:/basic_andnot3/in_2 0 0, 1 {500 ps} -r 1000
force -freeze sim:/basic_andnot3/in_3 0 0, 1 {1000 ps} -r 2000
run

# ИЛИ-не 2 входа
vsim work.basic_ornot2
add wave sim:/basic_ornot2/*
force -freeze sim:/basic_ornot2/vdd 1 0
force -freeze sim:/basic_ornot2/vss 0 0
force -freeze sim:/basic_ornot2/in_1 0 0, 1 {250 ps} -r 500
force -freeze sim:/basic_ornot2/in_2 0 0, 1 {500 ps} -r 1000
run

# И-НЕ 2 входа
vsim work.basic_andnot2
add wave sim:/basic_andnot2/*
force -freeze sim:/basic_andnot2/vdd 1 0
force -freeze sim:/basic_andnot2/vss 0 0
force -freeze sim:/basic_andnot2/in_1 0 0, 1 {250 ps} -r 500
force -freeze sim:/basic_andnot2/in_2 0 0, 1 {500 ps} -r 1000
run