import RPi.GPIO as GPIO
import time

# Set the GPIO mode to BCM
GPIO.setmode(GPIO.BCM)

# Set the GPIO pin to an output
red_led_pin = 17
green_led_pin = 27
GPIO.setup(red_led_pin, GPIO.OUT)
GPIO.setup(green_led_pin, GPIO.OUT)

try:
    while True:
        # Turn the red LED on
        GPIO.output(red_led_pin, GPIO.HIGH)
        # Turn the green LED off
        GPIO.output(green_led_pin, GPIO.LOW)
        time.sleep(1)

        # Turn the red LED off
        GPIO.output(red_led_pin, GPIO.LOW)
        # Turn the green LED on
        GPIO.output(green_led_pin, GPIO.HIGH)
        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()
