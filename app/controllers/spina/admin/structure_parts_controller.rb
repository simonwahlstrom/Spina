module Spina
  module Admin
    class StructurePartsController < AdminController
      def destroy
        # Hack to allow removing attachments from pages
        @structure_part = StructurePart.find(params[:id])
        @structure_part.destroy
        redirect_to request.referrer
      end
    end
  end
end
