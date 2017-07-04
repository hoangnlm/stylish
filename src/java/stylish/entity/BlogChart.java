package stylish.entity;

import java.util.Comparator;

public class BlogChart {

    private String label;
    private int value;

    public BlogChart() {
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public static class BlogChartComparator implements Comparator<BlogChart> {

        @Override
        public int compare(BlogChart o1, BlogChart o2) {
            return o1.value - o2.value;
        }

    }
}
