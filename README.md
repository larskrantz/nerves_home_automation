# Nerves Home Automation
An experiment for controlling and reacting to stuff at home with an Raspberry Pi 2 and/or Zero.

## The Great Plan

Create something that can:

  * Control simple 433-stuff like Nexa, Proove and Anslut
  * React to and control Z-Wave equipment
  * Philips Hue

## Simple 433 - stuff

## Hardware on GPIO
[Sender and Receiver](https://www.kjell.com/se/sortiment/el-verktyg/elektronik/fjarrstyrning/sandar-och-mottagarmodul-433-mhz-p88905)

### Protocol
http://tech.jolowe.se/home-automation-rf-protocols/

## Nerves

To start your Nerves app:

  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

### Learn more

  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves
  * Source: https://github.com/nerves-project/nerves
