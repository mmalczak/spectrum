using System;

public class main
{
    public static void Main(string[] args)
    {
        double[] a = {1.0000, -5.4483, 14.1853, -24.4566, 32.4873, -35.7754,
                      33.4123, -26.4480, 17.5025, -9.3406,   3.7415, -0.9876,
                      0.1276};

        double[] b = {0.0534, -0.2422, 0.4266, -0.3604, 0.1431, 0.0095,
                     -0.1382, 0.2757, -0.3167, 0.2364, -0.1319, 0.0725, -0.0400,
                     0.0141, -0.0019};
        double[] x = {1, 2, 3, 4};
        IIR iir = new IIR();
        double [] output = iir.Filter(b, a, x);
        Console.WriteLine("[{0}]", string.Join(", ", output));
    }
}

public class IIR
{
    public double[] Filter(double[] b, double[] a, double[] x)
    {
        int d_a = a.Length-1;
        int d_b = b.Length-1;
        double [] out_buf = new double[x.Length];
        for(int i = 0; i<x.Length; i++)
        {
            double output = 0;
            for(int j=0; j<=d_b; j++)
            {
                if(i>=j)
                    output += b[j]*x[i-j];
            }
            for(int j=1; j<=d_a; j++)
            {
                if(i>=j)
                    output -= a[j]*out_buf[i-j];
            }
            out_buf[i] = output;
        }
        return out_buf;
    }
}
