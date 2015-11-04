
#ifndef _BASICRANK_H_
#define _BASICRANK_H_

#include "picsearch/ImageMeta.h"
#include "picsearch/tPage.h"

static int basicRank(ImageMeta *meta)
{
    double rank = 0;
    bool bad = false;
    bool small = false;
    bool little_bad = false;
    int width = meta->width;
    int height = meta->height;

    int aveLen = (width + height)/2;
    int diff = aveLen - 750;
    if(diff < 0) diff = 0 - diff;
    int tmp = (1 - diff / 750.0) * 80;
    if(tmp < 0) tmp = 0;
    rank += tmp;

    int longLen = width > height ? width : height;
    if(longLen <= 200)
    {
        small = true;
    }

    double ratio = ((double)width) / height;
    if(ratio > 2.5 || ratio < 0.4)
    {
        bad = true;
    }

    int byte_num = meta->byte_num;
    if(small)
    {
        if(byte_num < 30000 && byte_num > 5000)
        {
            rank +=30;
        }
    }
    else
    {
        if(byte_num > 300000)
        {
            rank += 0;
        }
        else if(byte_num > 200000)
        {
            rank += 30;
        }
        else if(byte_num > 100000)
        {
            rank += 43;
        }
        else if(byte_num > 50000)
        {
            rank += 37;
        }
        else if(byte_num > 20000)
        {
            rank += 10;
        }
        else if(byte_num > 10000)
        {
            rank += 0;
            little_bad = true;
        }
        else
        {
            rank = 0;
        }
    }

    if(bad)
    {
        rank *= 0.66;
    }
    else if(little_bad)
    {
        rank *= 0.8;
    }

    return rank;
}

static int basicRank(tPage* page)
{
    double rank = 0;
    bool bad = false;
    bool small = false;
    bool little_bad = false;
    int width = page->width;
    int height = page->height;

    int aveLen = (width + height)/2;
    int diff = aveLen - 750;
    if(diff < 0) diff = 0 - diff;
    int tmp = (1 - diff / 750.0) * 80;
    if(tmp < 0) tmp = 0;
    rank += tmp;

    int longLen = width > height ? width : height;
    if(longLen <= 200)
    {
        small = true;
    }

    double ratio = ((double)width) / height;
    if(ratio > 2.5 || ratio < 0.4)
    {
        bad = true;
    }

    int byte_num = page->byte_num;
    if(small)
    {
        if(byte_num < 30000 && byte_num > 5000)
        {
            rank +=30;
        }
    }
    else
    {
        if(byte_num > 300000)
        {
            rank += 0;
        }
        else if(byte_num > 200000)
        {
            rank += 30;
        }
        else if(byte_num > 100000)
        {
            rank += 43;
        }
        else if(byte_num > 50000)
        {
            rank += 37;
        }
        else if(byte_num > 20000)
        {
            rank += 10;
        }
        else if(byte_num > 10000)
        {
            rank += 0;
            little_bad = true;
        }
        else
        {
            rank = 0;
        }
    }

    if(bad)
    {
        rank *= 0.66;
    }
    else if(little_bad)
    {
        rank *= 0.8;
    }

    return rank;
}


#endif //_BASICRANK_H_
