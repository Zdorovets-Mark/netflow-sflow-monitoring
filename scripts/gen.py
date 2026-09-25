#!/usr/bin/env python3
import random
import argparse
from scapy.all import Ether, IP, UDP, wrpcap

NUM_SRC_IPS = 5000
NUM_DST_IPS = 5000

src_ip_pool = [f"192.168.{random.randint(0,255)}.{random.randint(1,254)}" for _ in range(NUM_SRC_IPS)]
dst_ip_pool = [f"{random.randint(1,223)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}" for _ in range(NUM_DST_IPS)]

def generate_pcap(num_packets, output_file):
    packets = []
    print(f"Generating {num_packets} packets with Ethernet headers...")
    for _ in range(num_packets):
        src_ip = random.choice(src_ip_pool)
        dst_ip = random.choice(dst_ip_pool)
        src_port = random.randint(1024, 65535)
        dst_port = random.choices(
            population=[443, 80, 53, 22, 3306, 5432],
            weights=[60, 30, 5, 3, 1, 1],
            k=1
        )[0]
        # Добавляем фиктивные MAC-адреса
        eth = Ether(src="00:11:22:33:44:55", dst="66:77:88:99:aa:bb")
        ip = IP(src=src_ip, dst=dst_ip)
        udp = UDP(sport=src_port, dport=dst_port)
        pkt = eth / ip / udp
        packets.append(pkt)
    wrpcap(output_file, packets)
    print(f"Saved {len(packets)} packets to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--num-packets", type=int, default=100000, help="Number of packets")
    parser.add_argument("--output", type=str, default="traffic.pcap", help="Output pcap file")
    parser.add_argument("--src-count", type=int, default=NUM_SRC_IPS)
    parser.add_argument("--dst-count", type=int, default=NUM_DST_IPS)
    args = parser.parse_args()

    #if args.src_count != NUM_SRC_IPS or args.dst_count != NUM_DST_IPS:
    #    global src_ip_pool, dst_ip_pool
    #    src_ip_pool = [f"192.168.{random.randint(0,255)}.{random.randint(1,254)}" for _ in range(args.src_count)]
    #    dst_ip_pool = [f"{random.randint(1,223)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}" for _ in range(args.dst_count)]

    generate_pcap(args.num_packets, args.output)
