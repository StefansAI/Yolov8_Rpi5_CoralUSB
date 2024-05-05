import csv
import os

for fname in sorted(os.listdir()):
	if fname.startswith("run_") and fname.endswith(".txt"):
		sum = 0
		cnt = 0
		with open(fname) as csvfile:
			reader = csv.reader(csvfile, delimiter=',', quoting=csv.QUOTE_NONE)
			for row in reader:
				if len(row) > 1 and row[-1].endswith('ms'):
					s = row[-1].strip().strip('ms')
					x = float(s)
					sum = sum + x
					cnt = cnt + 1

		avg = sum/cnt
		print("File= %s count= %d average= %.1f ms"%(fname,cnt,avg))
