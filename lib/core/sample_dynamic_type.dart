class SampleDynamicType<T> {
  String name;
  T data;

  SampleDynamicType(this.data, this.name);
}

class HowToUseSampleDynamicType {
  SampleDynamicType<int> test(String name) {
    SampleDynamicType<int> sample = SampleDynamicType<int>(12, name);

    return sample;
  }

    SampleDynamicType<String> test2(String name) {
    SampleDynamicType<String> sample = SampleDynamicType<String>('12', name);

    return sample;
  }
}
