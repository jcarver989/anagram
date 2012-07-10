Views = Views || {} 
Views.step1= () ->
  """
  <div class="modal fade" id="myModal">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Choose an Action</h3>
    </div>

    <div class="row-fluid">
      <div class="modal-body center">
        <div class="span12 center">
          <a href="#" class="circle-button screenshot" data-dismiss="modal">
            <span class="glyph general">p</span>
          </a>
          <h3>Screenshot</h3>
        </div>

      </div>
    </div>
  </div>
  """

Views.step2 = () ->
  """
    <div class="modal fade" id="myModal2">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Setup Your Review</h3>
    </div>

      <div class="modal-body center">
         <form class="form-horizontal" id="titleAndReviewers">
          <fieldset>
            <div class="control-group">
              <label class="control-label" for="input01">Review Title</label>
              <div class="controls">
                <input type="text" class="input-xlarge" id="input01" name="title">
              </div>
            </div>

            <div class="control-group" style="display: none;">
              <label class="control-label" for="input02">Reviewers</label>
              <div class="controls">                
                <select  style="display: none;" multiple="" class="chzn-select" tabindex="-1" id="input02" name="reviewers">
                <option value=""></option>
                <option value="alex@bizo.com">Alex</option>
                <option value="josh@bizo.com">Josh</option>
                <option value="kip@bizo.com">Kip</option>
                <option value="stephen@bizo.com">Stephen</option>
                <option value="larry@bizo.com">Larry</option>
                <option value="darren@bizo.com">Darren</option>
                <option value="donnie@bizo.com">Donnie</option>
                <option value="mark@bizo.com">Mark</option>
                <option value="timo@bizo.com">Timo</option>
                <option value="tony@bizo.com">Tony</option>
                <option value="pat@bizo.com">Pat</option>
              </select>              
              </div>
            </div>
        </fieldset>
        </form>

        
      </div>
        <div class="modal-footer">
          <a href="#" id="saveReview" class="btn btn-success">Create Review</a>
        </div>
  </div>
  """

Views.step3 = () ->
  """
    <div class="modal fade" id="myModal3">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">x</button>
        <h3>Boom! Saved that shiznit to the cloud baby!</h3>
      </div>

          <div class="modal-footer">
            <a href="#" id="goToReview" class="btn btn-success"><i class="icon-share icon-white"></i> Go to Review</a>
          </div>
    </div>
  """
