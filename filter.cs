using System;
using IIR;

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
        Filter iir = new Filter(a, b);
        Console.WriteLine(iir.get_sample_out(1.0));
        Console.WriteLine(iir.get_sample_out(2.0));
        Console.WriteLine(iir.get_sample_out(3.0));
        Console.WriteLine(iir.get_sample_out(4.0));
    }

}

namespace IIR
{
   public class Filter
   {
        private double[] a;
        private double[] b;
        private int d_a;
        private int d_b;
        private double[] in_buf;// = new double[3+1];
        private double[] out_buf;// = new double[2];

        public Filter(double[] a, double[] b)
        {
            this.a = a;
            this.b = b;
            this.d_a = a.Length-1;
            this.d_b = b.Length-1;
            this.in_buf = new double[this.d_b+1];
            this.out_buf = new double[this.d_a];
        }

        public double get_sample_out(double sample_in)
        {
            double sample_out = 0;
            for(int i=d_b; i>=0; i--)
            {
                if(i>0)
                    in_buf[i] = in_buf[i-1];
                else
                    in_buf[i] = sample_in;
                sample_out += in_buf[i]*b[i];
            }
            for(int i=d_a-1; i>=0; i--)
            {
                sample_out -= out_buf[i]*a[i+1];
                if(i>0)
                    out_buf[i] = out_buf[i-1];
                else
                    out_buf[0] = sample_out;

            }
            return sample_out;
        }

   }


}

