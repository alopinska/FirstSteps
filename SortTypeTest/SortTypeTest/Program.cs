using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SortTypeTest
{
    class Program
    {
        static void Main(string[] args)
        {
            int sortOp = 10;
            StreamWriter file = new StreamWriter("SortTest.txt");
            Stopwatch time = new Stopwatch();
            int[] array = new int[200000];
            Action<int[], int>[] distributions = { Methods.Distributions.IncreasingDistribution, Methods.Distributions.DecreasingDistribution, Methods.Distributions.ConstantDistribution, Methods.Distributions.RandomDistribution, Methods.Distributions.VShapeDistribution };
            Action<int[], int>[] sorters = { Methods.SortType.InsertionSort, Methods.SortType.SelectionSort, Methods.SortType.CocktailSort, Methods.SortType.HeapSort };
            foreach (var distribution in distributions)
            {
                for (int i = 50000; i < array.Length; i += 10000)
                {
                    foreach (var sorter in sorters)
                    {
                        double elapsedTime = 0;
                        for (int j = 0; j < sortOp; j++)
                        {
                            distribution(array, i);
                            time.Start();
                            sorter(array, i);
                            time.Stop();
                            double iterationTime = time.Elapsed.TotalSeconds;
                            elapsedTime += iterationTime;
                        }
                        double SecondsMid = elapsedTime / sortOp;
                        Console.WriteLine("{0}: {1}", i, SecondsMid.ToString("F4"));
                        file.WriteLine("{0}: {1}", i, SecondsMid.ToString("F4"));
                        time.Reset();
                    }
                }
                Console.WriteLine();
                file.WriteLine();
            }
            file.Close();
        }        
    }
}
