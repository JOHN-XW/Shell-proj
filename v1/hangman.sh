#!/bin/bash
HIDEWORD=`awk '{printf "%s\n",$(rand*NF+1)}' hangman.dic`
#HIDEWORD=`awk '{printf "%s\n",$(NF)}' hangman.dic`
HANGMAN="O-|--<"
h_idx=1
try_cnt=0
error_cnt=0
while [ $h_idx -le ${#HIDEWORD} ]
do
printf "-"
GUESS_WORD=$GUESS_WORD"-"
h_idx=`expr $h_idx + 1`
done
printf "\nPlease input your guess:\n";
while read guess
do
        guess_char=`echo $guess|cut -c1-1`
        g_idx=1
        match_flag=0

        while [ $g_idx -le ${#HIDEWORD} ]
        do
                r_char=`echo $HIDEWORD|cut -c$g_idx-$g_idx`
                if [ $guess_char = $r_char ]
                then
                        match_flag=1
                        if [ $g_idx -eq 1 ]
                        then    t=`expr $g_idx + 1`
                                GUESS_WORD=$r_char`echo $GUESS_WORD|cut -c$t-`
                        elif [ $g_idx -eq ${#HIDEWORD} ]
                        then    t=`expr $g_idx - 1`
                                GUESS_WORD=`echo $GUESS_WORD|cut -c1-$t`$r_char
                        else
                                t1=`expr $g_idx - 1`
                                t2=`expr $g_idx + 1`
                                GUESS_WORD=`echo $GUESS_WORD|cut -c1-$t1`$r_char`echo $GUESS_WORD|cut -c$t2-`
                        fi
                        g_idx=`expr $g_idx + 1`
                else
                        g_idx=`expr $g_idx + 1`
                fi
        done

        if [ $match_flag -eq 0 ]
        then
                error_cnt=`expr $error_cnt + 1`
                if [ $error_cnt -ge ${#HIDEWORD} ]
                then    printf "%s\nSorry,the word is %s!\n" $HANGMAN $HIDEWORD
                        exit
                fi
        fi

        if [ $GUESS_WORD = $HIDEWORD ]
        then
                printf "%s\nYou got it,the word is %s.\n" $GUESS_WORD $HIDEWORD
                exit
        else
                printf "%s\nPlease input your guess:\n" $GUESS_WORD;
        fi

done
