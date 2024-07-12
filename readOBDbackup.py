import obd
import time 

connection = obd.Async(delay_cmds=0)
connection.watch(obd.commands.RPM)
connection.watch(obd.commands.SPEED)
connection.watch(obd.commands.COOLANT_TEMP)
connection.watch(obd.commands.CONTROL_MODULE_VOLTAGE)
connection.start() # start the async update loop

def retry():
    connection = obd.OBD() 

def update():

    speed = connection.query(obd.commands.SPEED)
    rpm = connection.query(obd.commands.RPM)
    temp = connection.query(obd.commands.COOLANT_TEMP)
    battery = connection.query(obd.commands.CONTROL_MODULE_VOLTAGE)

    if speed.value is None:
        return [0, 0, 0, 0, 1]

    else:
        print(int(speed.value.to('mph').magnitude))
        print(int(rpm.value.magnitude))
        print(int(temp.value.to('fahrenheit').magnitude))
        print(int(battery.value.magnitude))
        return [int(speed.value.to('mph').magnitude), int(rpm.value.magnitude), int(temp.value.to('fahrenheit').magnitude), int(battery.value.magnitude), 0]