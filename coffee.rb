require 'serialport'

#params for serial port
port_str = "/dev/tty.usbserial-A6V8IWSN"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
sp.sync = true

command = ARGV[0] + "\r\n"

command.each_char do |char|
  bchar = char.ord.to_s(16).rjust(2, '0').chars.reverse.map{|c| c.hex.to_s(2).rjust(4, '0').reverse}.join
  for i in 0...4
    byte = "11111111"
    byte[2] = bchar[i*2+1]
    byte[5] = bchar[i*2]
    sp.write byte.to_i(2).chr
    sp.flush
  end
  sleep 0.008
end
