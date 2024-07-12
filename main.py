# Daniel Miller July 2024
# dashUI digital dashboard

import sys
import random

from PyQt5.QtGui import QGuiApplication, QFont, QCursor
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import Qt, QTimer, QObject, pyqtSignal, pyqtSlot

from time import strftime, localtime
from datetime import datetime

import readOBD

app = QGuiApplication(sys.argv)
mainFont = QFont("noto sans")
app.setFont(mainFont)
app.setOverrideCursor(Qt.BlankCursor)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.load('main.qml')

class Backend(QObject):

    #Signal for data
    data = pyqtSignal(int, int, int, int, arguments=['speed', 'rpm', 'temp', 'battery'])
    time = pyqtSignal(str, str, int, bool, arguments=['hour_text', 'minute_text', 'second', 'PM'])

    def __init__(self):
        super().__init__()

        #100ms timer for data update
        self.timer1 = QTimer()
        self.timer1.setInterval(100)
        self.timer1.timeout.connect(self.update_data)

        #500ms timer for time update
        self.timer2 = QTimer()
        self.timer2.setInterval(500)
        self.timer2.timeout.connect(self.update_time)
        self.timer2.start()

    #Once the startup animation is finished, this starts the timer to poll the OBD connection 
    @pyqtSlot()
    def load_data(self):
        
        print("OBD2 started")
        response = readOBD.update()

        if (response[4] == 1):
            print("OBD2 connection failed")

        else:
            print("OBD2 connection successful")
            self.data.emit(response[0], response[1], response[2], response[3])
            self.timer1.start()

    def update_data(self):

        print("Updating data")
        response = readOBD.update()
        self.data.emit(response[0], response[1], response[2], response[3])

    def update_time(self):
        
        time = localtime()
        hour = strftime("%-I", localtime()) 
        minute = strftime("%M", localtime()) 

        if (strftime("%p").upper() == "PM"):
            PM = True
        else:
            PM = False
  
        self.time.emit(hour, minute, time.tm_sec, PM)

backend = Backend()
engine.rootObjects()[0].setProperty('backend', backend )
backend.update_time()

sys.exit(app.exec())