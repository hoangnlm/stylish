package stylish.entity;

import java.util.Comparator;

public class QuantityOrderChart {

    private String label;
    private int value;

    public QuantityOrderChart() {
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

    public static class QuantityOrderChartComparator implements Comparator<QuantityOrderChart> {

        @Override
        public int compare(QuantityOrderChart o1, QuantityOrderChart o2) {
            return o1.value - o2.value;
        }

    }
}
