import numpy as np
import cv2
import os


def fusion_lab(rgb, ir):
    rgb_lab = cv2.split(cv2.cvtColor(rgb, cv2.COLOR_BGR2LAB))
    # ir_rgb = cv2.cvtColor(ir, cv2.COLOR_GRAY2BGR)
    ir_rgb = cv2.applyColorMap(ir, cv2.COLORMAP_JET)
    cv2.imshow('ir_rgb', ir_rgb)
    ir_lab = cv2.split(cv2.cvtColor(ir_rgb, cv2.COLOR_BGR2LAB))
    # print(rgb_lab.shape)

    l = ir_lab[0]
    a = ir_lab[1]
    b = rgb_lab[2]
    dst_lab = cv2.merge([l, a, b])

    l = rgb_lab[0]
    a = ir_lab[1]
    b = rgb_lab[2]
    dst = cv2.merge([l, a, b])

    print(dst.shape)
    cv2.imshow('dst_lab', dst_lab)
    cv2.imshow('dst_lab_rgb', dst)


def fusion_cwd(rgb, ir):
    rgb_lab = cv2.split(cv2.cvtColor(rgb, cv2.COLOR_BGR2LAB))
    # print(rgb_lab.shape)
    rgb_hsv = cv2.split(cv2.cvtColor(rgb, cv2.COLOR_BGR2HSV))
    # print(rgb_lab.shape)

    ir_inv = cv2.bitwise_not(ir)
    dst1_rgb = cv2.merge([ir_inv, rgb_hsv[2], ir])
    dst1_lab = cv2.split(cv2.cvtColor(dst1_rgb, cv2.COLOR_BGR2LAB))

    l = rgb_lab[0]
    a = rgb_lab[1]
    b = dst1_lab[2]

    dst2_hsv = cv2.split(cv2.cvtColor(cv2.cvtColor(cv2.merge([l, a, b]), cv2.COLOR_LAB2BGR), cv2.COLOR_BGR2HSV))
    dst3_hsv = cv2.merge([rgb_hsv[0], rgb_hsv[1], dst2_hsv[2]])
    dst = cv2.cvtColor(dst3_hsv, cv2.COLOR_HSV2BGR)

    print(dst.shape)
    # cv2.imshow('dst3_hsv', dst3_hsv)
    cv2.imshow('dst_cwd', dst)


def add(rgb, ir, alpha, name='blend'):
    beta = (1.0 - alpha)
    dst = cv2.addWeighted(rgb, alpha, np.stack([ir]*3, axis=-1), beta, 0.0)

    cv2.imshow(name, dst)

def test_add(rgb, ir):
    for alpha in np.arange(0, 1, 0.1):
        add(rgb, ir, alpha, 'alpha %f'%alpha)

    cv2.imshow('add', cv2.addWeighted(rgb, 1, np.stack([ir]*3, axis=-1), 1, 0.0))


dir = '../kaist-rgbt/images'
# set = 'set00' # 00 - 11
# video = 'V000' # Check if exists in chosen set
# img = 'I00000.png'
# set = 'set04' # 00 - 11
# video = 'V001' # Check if exists in chosen set
# img = 'I01345.png'
set = 'set01' # 00 - 11
video = 'V005' # Check if exists in chosen set
img = 'I00210.png'

rgb = cv2.imread(os.path.join(dir, set, 'Visible_' + video, img), -1 | cv2.IMREAD_ANYDEPTH)
print(rgb.shape)
ir = cv2.imread(os.path.join(dir, set, 'LWIR_' + video, img), cv2.IMREAD_ANYDEPTH)
print(ir.shape)

cv2.imshow('rgb', rgb)
cv2.imshow('ir', ir)
# cv2.imshow('ir3', np.stack([ir]*3, axis=-1))

# fusion_lab(rgb, ir)
# fusion_cwd(rgb, ir)
# add(rgb, ir, 0.4)
test_add(rgb, ir)

cv2.waitKey()
cv2.destroyAllWindows()


