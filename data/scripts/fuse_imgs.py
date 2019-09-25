import numpy as np
import cv2
import os

dir = '/media/shweta.mahajan/Daten/GitHub/rgbt-ped-detection/data/kaist-rgbt/images'
sets = [('00', 9), ('01', 6), ('02', 5), ('03', 2), ('04', 2), ('05', 1), ('06', 5), ('07', 3), ('08', 3), ('09', 1), ('10', 2), ('11', 2)] # 00 - 11
set_prefix = 'set'
v_prefix = 'V00'
vout_prefix = 'aV00'
# vout_prefix = 'fV00'

o_dir = '/media/shweta.mahajan/Transcend2TB/images'
# o_dir = dir

def fusion_lab(ir, rgb):
    rgb_lab = cv2.split(cv2.cvtColor(rgb, cv2.COLOR_BGR2LAB))
    ir_rgb = cv2.applyColorMap(ir, cv2.COLORMAP_JET)
    ir_lab = cv2.split(cv2.cvtColor(ir_rgb, cv2.COLOR_BGR2LAB))

    l = rgb_lab[0]
    a = ir_lab[1]
    b = rgb_lab[2]
    cmb = cv2.merge([l, a, b])

    return cmb


for set, n_seq in sets:
    print('Started set%s' % set)
    i = 0
    while i < n_seq:
        print('Video sequence %d'%i)

        d = os.path.join(o_dir, set_prefix + set, vout_prefix + str(i))
        if not os.path.exists(d):
            os.makedirs(d, exist_ok=True)

        img_names = sorted(os.listdir(os.path.join(dir, set_prefix + set, 'Visible_' + v_prefix + str(i))))
        print('Found %d files'%len(img_names))
        for img in img_names:
            rgb = cv2.imread(os.path.join(dir, set_prefix + set, 'Visible_' + v_prefix + str(i), img), -1 | cv2.IMREAD_ANYDEPTH)
            # print(rgb.shape)
            ir = cv2.imread(os.path.join(dir, set_prefix + set, 'LWIR_' + v_prefix + str(i), img), cv2.IMREAD_ANYDEPTH)
            # print(ir.shape)

            cmb = cv2.addWeighted(rgb, 0.5, cv2.cvtColor(ir, cv2.COLOR_GRAY2BGR), 0.5, 0.0)
            # cmb = fusion_lab(ir, rgb)

            assert cmb.shape[-1] == 3
            cv2.imwrite(os.path.join(d, img), cmb)

            # [blend_images]
            # beta = (1.0 - 0.5)
            # dst = cv2.addWeighted(rgb, 0.5, ir, beta, 0.0)
            # [blend_images]
            # [display]
            # dst = np.concatenate((rgb, np.reshape(ir, (ir.shape[0], ir.shape[1], 1))), -1)

            '''
            rgb_lab = cv2.split(cv2.cvtColor(rgb, cv2.COLOR_BGR2LAB))
            # print(rgb_lab.shape)

            l = rgb_lab[0]
            a = ir
            b = rgb_lab[2]

            dst_lab = cv2.merge([l, a, b])
            dst = cv2.cvtColor(dst_lab, cv2.COLOR_LAB2BGR)

            print(dst.shape)
            '''

        i += 1


print('Done!')
