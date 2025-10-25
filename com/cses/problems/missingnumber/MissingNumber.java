package com.cses.problems.missingnumber;

import java.util.Scanner;

public class MissingNumber {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int sum = 0;
        for (int i = 0; i < n - 1; i++) {
            sum += sc.nextInt();
        }
        int total = n % 2 == 0 ? (n / 2) * (n + 1) : n * ((n + 1) / 2);
        System.out.println(total - sum);
        sc.close();
    }
}
