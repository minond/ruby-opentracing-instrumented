RSpec.describe OpenTracing::Instrumented do
  class MyOwnCommand
    include OpenTracing::Instrumented

    traced :call, :helper1, :helper2

    def call
      helper1
      helper2

      :ok
    end

    def helper1
    end

    def helper2
    end
  end

  before { OpenTracing.global_tracer = tracer }

  let(:tracer) { OpenTracingTestTracer.build }
  let(:spans) { tracer.spans }
  let(:parent) { spans.first }
  let(:cmd) { MyOwnCommand.new }

  it "has a version number" do
    expect(OpenTracing::Instrumented::VERSION).not_to be nil
  end

  describe ".traced" do
    it "returns the return value of the original method" do
      expect(cmd.call).to be :ok
    end

    it "creates spans under the active span" do
      OpenTracing.start_active_span("parent") { cmd.call }
      expect(spans[1].context.parent_id).to eq parent.context.span_id
    end

    it "creates spans for each traced method" do
      expect { cmd.call }.to change { spans.size }.by 3
    end

    it "follows the operation naming convention" do
      cmd.call
      expect(parent.operation_name).to eq "MyOwnCommand.call"
    end
  end
end
