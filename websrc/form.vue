<template>

	<form action="/form">
	  <div class="mb-3">

		<label for="FormString" class="form-label">FormString
			<input type="text" name="FormString" class="form-control" id="FormString">
		</label>

		<label for="FormNumber" class="form-label">FormNumber
			<input type="number" name="FormNumber" id="FormNumber">
		</label>
		
		<label for="FormFloat" class="form-label">FormFloat
			<input type="number" name="FormFloat" id="FormFloat" step="0.00000000000001">
		</label>

		<label for="FormBool" class="form-label">FormBool
			<input type="checkbox" name="FormBool" id="FormBool">
		</label>

	</div>

		<button type="submit" class="btn btn-primary">Search</button>

	</form>
</template>

<style lang="scss">
@import "~bootstrap/scss/bootstrap";


form {
	width:  50%;
}
</style>