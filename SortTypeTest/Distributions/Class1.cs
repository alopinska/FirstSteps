using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Methods
{
    public class Distributions
    {
        public static void IncreasingDistribution(int[] t, int length)
        {
            for (int i = 0; i < length; i++) t[i] = i;
        }
        public static void DecreasingDistribution(int[] t, int length)
        {
            for (int i = 0; i < length; i++) t[i] = length - i;
        }
        public static void ConstantDistribution(int[] t, int length)
        {
            for (int i = 0; i < length; i++) t[i] = 5;
        }
        public static void RandomDistribution(int[] t, int length)
        {
            Random rnd = new Random(Guid.NewGuid().GetHashCode());
            for (int i = 0; i < length; i++) t[i] = rnd.Next(length);
        }
        public static void VShapeDistribution(int[] t, int length)
        {
            for (int i = 0; i < length / 2; i++) t[i] = length - (2 * i + 1);
            for (int i = length / 2; i < length; i++) t[i] = 2 * i - length;
        }
    }
    public class SortType
    {
        public static void InsertionSort(int[] t, int currentLength)
        {
            int i, j, tmp;
            for (i = 1; i < currentLength + 1; i++)
            {
                j = i;
                tmp = t[j];
                while ((j > 0) && tmp < t[j - 1])
                {
                    t[j] = t[j - 1];
                    t[j - 1] = tmp;
                    j--;
                }
            }
        }
        public static void SelectionSort(int[] t, int currentLength)
        {
            int i, j, min, tmp;
            for (i = 0; i < currentLength; i++)
            {
                min = i;
                for (j = i + 1; j < currentLength + 1; j++)
                {
                    if (t[j] < t[min]) min = j;
                }
                if (min != i)
                {
                    tmp = t[i];
                    t[i] = t[min];
                    t[min] = tmp;
                }
            }
        }
        public static void CocktailSort(int[] t, int currentLength)
        {
            int i, j, tmp;
            bool sorted = false;
            for (i = 0; i < currentLength / 2; i++)
            {
                for (j = i; j < currentLength - i - 1; j++)
                {
                    if (t[j] > t[j + 1])
                    {
                        tmp = t[j];
                        t[j] = t[j + 1];
                        t[j + 1] = tmp;
                        sorted = true;
                    }
                }
                for (j = currentLength - 2 - i; j > i; j--)
                {
                    if (t[j] < t[j - 1])
                    {
                        tmp = t[j];
                        t[j] = t[j - 1];
                        t[j - 1] = tmp;
                        sorted = true;
                    }
                }
                if (sorted == false) break;
            }
        }
        public static void HeapSort(int[] t, int currentLength)
        {
            MakeHeap(t, currentLength);
            int n = currentLength;
            while (n > 1)
            {
                int root = t[0];
                t[0] = t[n - 1];
                t[n - 1] = root;
                n = n - 1;
                FixHeap(t, 0, n);
            }
        }
        static void MakeHeap(int[] t, int currentLength)
        {
            for (int i = currentLength / 2 - 1; i >= 0; i--) FixHeap(t, i, currentLength);
        }
        static void FixHeap(int[] t, int node, int length)
        {
            int i = node;
            int j = 2 * i + 1;
            int k = 2 * i + 2;

            if (j < length && t[j] > t[i]) i = j;
            if (k < length && t[k] > t[i]) i = k;
            if (i != node)
            {
                int tmp = t[node];
                t[node] = t[i];
                t[i] = tmp;
                FixHeap(t, i, length);
            }
        }
    }
}
