import sys
import os
import glob
import argparse


parser = argparse.ArgumentParser()
parser.add_argument('-o', '--output', type=str, help="output folder.")
parser.add_argument('-g', '--gt', help="ground truth.", action="store_true")
# argparse receiving list of classes to be ignored
parser.add_argument('-i', '--ignore', nargs='+', type=str, help="ignore a list of classes.")
parser.add_argument('-occ', '--occlusion', type=int, help="this and values above are considered occluded.")
parser.add_argument('-d', '--dir', type=str, help="ground truth directory.")
args = parser.parse_args()

## create the output dir if it doesn't exist already
if not os.path.exists(args.output):
  os.makedirs(args.output)

# if there are no classes to ignore then replace None by empty list
if args.ignore is None:
    args.ignore = []

# create Caltech format files
txt_list = glob.glob(os.path.join(args.dir + '*.txt'))
if len(txt_list) == 0:
  print("Error: no .txt files found in input directory")
  sys.exit()
for tmp_file in txt_list:
  file_id = os.path.basename(os.path.normpath(tmp_file))

  with open(tmp_file, 'r') as in_f:
    lines_list = in_f.readlines()
  # remove whitespace characters like `\n` at the end of each line
  lines_list = [x.strip() for x in lines_list]

  out = ""

  for line in lines_list:
    if args.gt:
      class_name, left, top, right, bottom, _difficult, occlusion, _v = line.split()
      w = float(right) - float(left)
      h = float(bottom) - float(top)
      if args.occlusion:
        if int(occlusion) >= args.occlusion:
          occ = 1
        else:
          occ = 0
      else:
        occ = int(occlusion)
      ign = 0
      # check if class is in the ignore list
      if class_name in args.ignore:
        ign = 1

      out = out + ("%s %s %s %f %f %d %f %f %f %f %d %d\n"% (class_name, left, top, w, h, occ, 0, 0, 0, 0, ign, 0))
    else:
      class_name, score, left, top, right, bottom = line.split()
      # check if class is in the ignore list, if yes, skip from adding
      if class_name in args.ignore:
        continue

      w = float(right) - float(left)
      h = float(bottom) - float(top)

      out = out + ("%s %s %f %f %s\n"% (left, top, w, h, score))
          
  # 1. create new file (Caltech format)
  with open(os.path.join(args.output, file_id), 'w') as f:
    f.write(out)

print("Conversion completed!")
