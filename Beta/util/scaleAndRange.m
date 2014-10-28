function [p1,p2]=scaleAndRange(point,origAmt,newAmt,window)
    factor = origAmt/newAmt;
    newPoint = factor*point;
    p1 = int32(newPoint-(window/2));
    p2 = int32(newPoint+(window/2));
    