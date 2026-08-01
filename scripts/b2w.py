import sys

def b2w(input_hex, output_hex):
    bytes_list = []

    with open(input_hex) as input:
        for line in input:
            
            if line.startswith('@'):
                continue
            else:
                line = line.split()
                bytes_list.extend(line)

    grouped_bytes = []
    words = []

    for i in range(0, len(bytes_list), 4):
        grouped_bytes = bytes_list[i:i+4]
        temp = ""
        for j in range(3, -1, -1):
            temp += grouped_bytes[j]
        words.append(temp)
    with open(output_hex, 'w') as output:
        for word in words:
            output.write(word + "\n");

if __name__ == "__main__":
    b2w(sys.argv[1], sys.argv[2])

        