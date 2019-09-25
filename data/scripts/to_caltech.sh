#!/usr/bin/env bash

#python convert_txt_caltech.py \
# -o /media/shweta.mahajan/Daten/Human_Detection/Datasets/CaltechPedestrians/faster-rcnn_resnet101_50p/caltech/ \
# -d /media/shweta.mahajan/Daten/Human_Detection/Datasets/CaltechPedestrians/faster-rcnn_resnet101_50p/

#python convert_txt_caltech.py \
# -o /media/shweta.mahajan/Transcend/rgbt/faster-rcnn_resnet101_100p/caltech/ \
# -d /media/shweta.mahajan/Transcend/rgbt/faster-rcnn_resnet101_100p/ \
# -i people cyclist

python convert_txt_caltech.py \
 -o /media/shweta.mahajan/Transcend/ground-truth-all/caltech/ \
 -d /media/shweta.mahajan/Transcend/ground-truth-all/ \
 -g \
 -occ 2