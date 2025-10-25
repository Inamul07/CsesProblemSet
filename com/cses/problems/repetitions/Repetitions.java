package com.cses.problems.repetitions;

import java.util.Scanner;

public class Repetitions {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine();
        char curr = s.charAt(0);
        int maxCount = 0,
            currCount = 0;
        for (int i = 0; i < s.length(); i++) {
            if (curr == s.charAt(i)) currCount++;
            else {
                currCount = 1;
                curr = s.charAt(i);
            }
            maxCount = Math.max(maxCount, currCount);
        }
        System.out.println(maxCount);
        sc.close();
    }
}
